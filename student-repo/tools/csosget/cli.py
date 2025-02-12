#!/usr/bin/env python3
import click
import os
import requests
from pathlib import Path
import json
from rich.console import Console
from rich.progress import Progress
from rich import print as rprint


# FLOW:
# CLI opens browser for GitHub auth
# User logs in with GitHub
# Server gets token and stores in Redis
# CLI polls /get-token endpoint until token is available
# CLI saves token to local config file

console = Console()

CONFIG_DIR = Path.home() / '.config' / 'csos'
CONFIG_FILE = CONFIG_DIR / 'config.json'
SERVER_URL = "https://csos-example-server.onrender.com"







def load_config():
    if CONFIG_FILE.exists():
        return json.loads(CONFIG_FILE.read_text())
    return {}








def save_config(config):
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    CONFIG_FILE.write_text(json.dumps(config, indent=2))

@click.group()
def cli():
    """CSOS Lesson Management Tool"""
    pass










@cli.command()
def init():
    """Initialize csosget configuration"""
    if not CONFIG_DIR.exists():
        CONFIG_DIR.mkdir(parents=True)
    
    config = {
        "server_url": SERVER_URL,
        "initialized": True
    }
    save_config(config)
    rprint("[green]✓[/green] Initialized csosget configuration")









@cli.command()
def auth():
    """Authenticate with GitHub"""
    config = load_config()
    auth_url = f"{SERVER_URL}/auth/github/login"
    rprint(f"[yellow]![/yellow] Opening browser for GitHub authentication...")
    click.launch(auth_url)
    
    # Poll server for token
    with console.status("Waiting for GitHub authentication...") as status:
        max_attempts = 30  # 30 seconds timeout
        for _ in range(max_attempts):
            try:
                response = requests.get(f"{SERVER_URL}/get-token")
                if response.status_code == 200:
                    token = response.json()["access_token"]
                    config["token"] = token
                    save_config(config)
                    rprint("[green]✓[/green] Authentication successful!")
                    return
            except:
                pass
            time.sleep(1)
            
        rprint("[red]×[/red] Authentication timed out. Please try again.")









@cli.command()
def list():
    """List available lessons"""
    config = load_config()
    if not config.get("token"):
        rprint("[red]×[/red] Please authenticate first: csosget auth")
        return
    
    headers = {"Authorization": f"Bearer {config['token']}"}
    response = requests.get(f"{SERVER_URL}/lessons", headers=headers)
    
    if response.status_code == 200:
        lessons = response.json()
        console.print("\n📚 Available Lessons:")
        for lesson in lessons:
            console.print(f"  • {lesson['name']} - {lesson['description']}")
    else:
        rprint("[red]×[/red] Failed to fetch lessons")




@cli.command()
@click.argument('lesson_name')
def get(lesson_name):
    """Download a specific lesson to src/ directory"""
    config = load_config()
    if not config.get("token"):
        rprint("[red]×[/red] Please authenticate first: csosget auth")
        return
    
    # Ensure src directory exists
    os.makedirs('src', exist_ok=True)
    
    headers = {"Authorization": f"Bearer {config['token']}"}
    download_url = f"{SERVER_URL}/lessons/{lesson_name}"
    
    with console.status(f"Downloading {lesson_name}..."):
        response = requests.get(download_url, headers=headers, stream=True)
        
        if response.status_code == 200:
            total_size = int(response.headers.get('content-length', 0))
            zip_path = os.path.join('src', f"{lesson_name}.zip")
            
            with open(zip_path, 'wb') as f:
                with Progress() as progress:
                    task = progress.add_task("[cyan]Downloading...", total=total_size)
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)
                        progress.update(task, advance=len(chunk))
            
            # Extract the zip file to src directory
            import zipfile
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall('src')
            
            # Remove the zip file after extraction
            os.remove(zip_path)
            
            rprint(f"[green]✓[/green] Downloaded and extracted {lesson_name} to src/")
        else:
            rprint(f"[red]×[/red] Failed to download lesson: {response.status_code}")


if __name__ == '__main__':
    cli()
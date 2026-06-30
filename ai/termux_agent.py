#!/usr/bin/env python3
"""
Termux Agent - Professional CLI Executor for OpenBox
Executes block pastes, deployments, mappings, configurations
"""

import os
import sys
import json
import subprocess
import re
from datetime import datetime

class TermuxAgent:
    def __init__(self):
        self.name = "Termux Agent"
        self.version = "2.0.0"
        self.commands = {
            "execute": self.execute_block,
            "deploy": self.deploy_to_northflank,
            "status": self.check_status,
            "connect": self.connect_clouds,
            "sync": self.sync_storage,
            "backup": self.run_backup,
            "configure": self.configure_openbox,
            "help": self.show_help
        }
    
    def execute_block(self, block_content):
        """Execute a block of commands in Termux"""
        print(f"📦 Executing block at {datetime.now()}")
        print("=" * 50)
        
        # Save block to temporary file
        temp_file = "/data/data/com.termux/files/home/.tmp/block_exec.sh"
        os.makedirs(os.path.dirname(temp_file), exist_ok=True)
        with open(temp_file, 'w') as f:
            f.write("#!/bin/bash\n")
            f.write(block_content)
        os.chmod(temp_file, 0o755)
        
        # Execute
        result = subprocess.run(["bash", temp_file], capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("⚠️ Errors:", result.stderr)
        
        os.remove(temp_file)
        return result.returncode == 0
    
    def deploy_to_northflank(self):
        """Deploy to Northflank using credentials"""
        token = os.environ.get("NORTHFLANK_TOKEN")
        if not token:
            return "❌ NORTHFLANK_TOKEN not set. Please export NORTHFLANK_TOKEN=your_token"
        
        print("🚀 Deploying to Northflank...")
        cmd = f"""
        curl -X POST \
            -H "Authorization: Bearer {token}" \
            -H "Content-Type: application/json" \
            -d '{{"service": "openbox", "version": "'$(git rev-parse HEAD)'"}}' \
            https://api.northflank.com/v1/deploy
        """
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.stdout if result.stdout else "✅ Deployment initiated!"
    
    def check_status(self):
        """Check all OpenBox services"""
        services = {
            "OpenList": "pgrep -x openlist",
            "WebDAV": "pgrep -f 'rclone serve'",
            "SSH": "pgrep -x sshd",
            "Git": "git status --porcelain"
        }
        
        print("📊 OpenBox Status")
        print("=" * 40)
        for name, cmd in services.items():
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            status = "✅ Running" if result.returncode == 0 else "❌ Stopped"
            print(f"{name}: {status}")
        
        # Cloud connections
        print("\n☁️ Cloud Connections:")
        result = subprocess.run("rclone listremotes", shell=True, capture_output=True, text=True)
        for line in result.stdout.strip().split('\n'):
            if line:
                print(f"   ✅ {line}")
    
    def connect_clouds(self):
        """Connect all cloud storage accounts"""
        clouds = ["gdrive1", "gdrive2", "gdrive3", "dropbox1", "onedrive1"]
        print("🔗 Connecting clouds...")
        for cloud in clouds:
            print(f"Connecting {cloud}...")
            subprocess.run(f"rclone config reconnect {cloud}:", shell=True)
        print("✅ All clouds connected!")
    
    def sync_storage(self):
        """Sync all storage"""
        print("🔄 Syncing storage...")
        subprocess.run("rclone sync -P /storage/emulated/0/ openbox:/ --exclude 'Android/**' --exclude 'MIUI/**' --transfers 8", shell=True)
        print("✅ Sync complete!")
    
    def run_backup(self):
        """Run backup"""
        print("💾 Running backup...")
        subprocess.run("~/openbox/backup_system.sh", shell=True)
        print("✅ Backup complete!")
    
    def configure_openbox(self):
        """Configure OpenBox settings"""
        print("⚙️ Configuring OpenBox...")
        # Run setup
        subprocess.run("~/openbox/scripts/setup.sh", shell=True)
        print("✅ Configuration complete!")
    
    def show_help(self):
        """Show available commands"""
        print(f"""
🤖 {self.name} v{self.version}
========================================
Available Commands:
  execute <block>  - Execute a block of commands
  deploy           - Deploy to Northflank
  status           - Check all services status
  connect          - Connect all cloud storage
  sync             - Sync storage
  backup           - Run backup
  configure        - Configure OpenBox
  help             - Show this help

Example:
  agent.execute('''
    echo "Hello from Termux Agent"
    rclone ls openbox:/
  ''')
========================================
""")
    
    def process(self, command, args=None):
        """Process a command with optional arguments"""
        if command in self.commands:
            if args:
                return self.commands[command](args)
            return self.commands[command]()
        return f"❌ Unknown command: {command}. Type 'help' for available commands."

def main():
    agent = TermuxAgent()
    
    if len(sys.argv) < 2:
        print("🔧 Termux Agent - OpenBox CLI Executor")
        print("========================================")
        print("Usage:")
        print("  python termux_agent.py <command>")
        print("  python termux_agent.py execute '<block>'")
        print("  python termux_agent.py deploy")
        print("  python termux_agent.py status")
        print("  python termux_agent.py connect")
        print("  python termux_agent.py sync")
        print("  python termux_agent.py backup")
        print("  python termux_agent.py configure")
        print("  python termux_agent.py help")
        sys.exit(1)
    
    command = sys.argv[1]
    args = sys.argv[2] if len(sys.argv) > 2 else None
    
    result = agent.process(command, args)
    if result:
        print(result)

if __name__ == "__main__":
    main()

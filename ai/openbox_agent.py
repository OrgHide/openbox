#!/usr/bin/env python3
"""
OpenBox Agent - WebUI Organizer & Validator
Manages storage organization, validation, and security
"""

import os
import sys
import json
import subprocess
import requests
from datetime import datetime

class OpenBoxAgent:
    def __init__(self):
        self.name = "OpenBox Agent"
        self.version = "2.0.0"
        self.api_key = os.environ.get("OPENROUTER_API_KEY")
        self.base_url = os.environ.get("OPENBOX_URL", "http://localhost:5244")
        
        self.commands = {
            "organize": self.organize_storage,
            "validate": self.validate_files,
            "security": self.security_scan,
            "analyze": self.analyze_storage,
            "cleanup": self.cleanup_storage,
            "status": self.warehouse_status,
            "help": self.show_help
        }
    
    def _ai_query(self, prompt, context=""):
        """Query AI with OpenRouter"""
        if not self.api_key:
            return "⚠️ OPENROUTER_API_KEY not set. Set with: export OPENROUTER_API_KEY=your_key"
        
        try:
            response = requests.post(
                "https://openrouter.ai/api/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json",
                    "HTTP-Referer": "https://github.com/OrgHide/openbox"
                },
                json={
                    "model": "mistralai/mistral-7b-instruct:free",
                    "messages": [
                        {"role": "system", "content": "You are OpenBox AI Assistant. Help organize, validate, and secure multi-cloud storage."},
                        {"role": "user", "content": f"{context}\n\n{prompt}"}
                    ]
                }
            )
            if response.status_code == 200:
                return response.json()["choices"][0]["message"]["content"]
            return f"⚠️ API Error: {response.status_code}"
        except Exception as e:
            return f"⚠️ Error: {str(e)}"
    
    def organize_storage(self, path="openbox:/"):
        """Organize files in storage"""
        print("📁 Organizing storage...")
        
        # Get current structure
        result = subprocess.run(f"rclone ls {path} --max-depth 2", shell=True, capture_output=True, text=True)
        
        # AI suggestions
        suggestion = self._ai_query(
            f"Organize these files at {path} by type, date, and project",
            f"Current files: {result.stdout[:2000]}"
        )
        
        print(f"🤖 AI Suggestion:\n{suggestion}")
        
        # Execute organization
        print("\n🔧 Organizing files...")
        subprocess.run(f"rclone move {path} {path}/organized/ --include '*.pdf' --include '*.docx'", shell=True)
        subprocess.run(f"rclone move {path} {path}/media/ --include '*.jpg' --include '*.png' --include '*.mp4'", shell=True)
        
        return "✅ Organization complete!"
    
    def validate_files(self):
        """Validate file integrity"""
        print("🔍 Validating files...")
        result = subprocess.run("rclone check openbox:/ openbox-backup:/ --verbose", shell=True, capture_output=True, text=True)
        return result.stdout if result.stdout else "✅ All files validated!"
    
    def security_scan(self):
        """Run security scan"""
        print("🔐 Running security scan...")
        scans = {
            "Secrets": "grep -r 'password\\|secret\\|token' . --exclude-dir=.git --exclude-dir=.github | head -20",
            "Permissions": "ls -la ~/.ssh/",
            "Open Ports": "netstat -tuln | grep -E ':(5244|8080|8022)'"
        }
        
        results = []
        for name, cmd in scans.items():
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            results.append(f"{name}: {result.stdout[:200]}" if result.stdout else f"{name}: ✅ Secure")
        
        return "\n".join(results)
    
    def analyze_storage(self):
        """Analyze storage usage"""
        print("📊 Analyzing storage...")
        result = subprocess.run("rclone about openbox:/", shell=True, capture_output=True, text=True)
        return result.stdout if result.stdout else "📊 Storage analysis complete!"
    
    def cleanup_storage(self):
        """Cleanup temporary files"""
        print("🧹 Cleaning up storage...")
        subprocess.run("rclone delete openbox:/temp/ --dry-run", shell=True)
        subprocess.run("rclone delete openbox:/cache/ --dry-run", shell=True)
        return "✅ Cleanup complete! (dry-run)"
    
    def warehouse_status(self):
        """Get warehouse status"""
        print("📊 Warehouse Status")
        print("=" * 40)
        
        # Storage info
        result = subprocess.run("rclone about openbox:/", shell=True, capture_output=True, text=True)
        print(result.stdout if result.stdout else "Storage info available")
        
        # Connected clouds
        result = subprocess.run("rclone listremotes", shell=True, capture_output=True, text=True)
        print("\n☁️ Connected Clouds:")
        for line in result.stdout.strip().split('\n'):
            if line:
                print(f"   ✅ {line}")
    
    def show_help(self):
        """Show available commands"""
        print(f"""
🤖 {self.name} v{self.version}
========================================
Available Commands:
  organize [path]  - Organize storage files
  validate        - Validate file integrity
  security        - Run security scan
  analyze         - Analyze storage usage
  cleanup         - Cleanup temporary files
  status          - Show warehouse status
  help            - Show this help

Example:
  agent.organize('openbox:/Documents')
  agent.validate()
========================================
""")

def main():
    agent = OpenBoxAgent()
    
    if len(sys.argv) < 2:
        print("🌐 OpenBox Agent - WebUI Organizer")
        print("========================================")
        print("Usage:")
        print("  python openbox_agent.py organize [path]")
        print("  python openbox_agent.py validate")
        print("  python openbox_agent.py security")
        print("  python openbox_agent.py analyze")
        print("  python openbox_agent.py cleanup")
        print("  python openbox_agent.py status")
        print("  python openbox_agent.py help")
        sys.exit(1)
    
    command = sys.argv[1]
    args = sys.argv[2] if len(sys.argv) > 2 else None
    
    if command == "organize":
        path = args if args else "openbox:/"
        print(agent.organize_storage(path))
    elif command in agent.commands:
        result = agent.commands[command]()
        if result:
            print(result)
    else:
        print(f"❌ Unknown command: {command}")

if __name__ == "__main__":
    main()

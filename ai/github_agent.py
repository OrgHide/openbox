#!/usr/bin/env python3
"""
OpenBox GitHub Agent - Repository Management
Manages GitHub operations, issues, PRs, and deployments
"""

import os
import sys
import json
import subprocess
import requests
from datetime import datetime

class GitHubAgent:
    def __init__(self):
        self.name = "OpenBox GitHub Agent"
        self.version = "2.0.0"
        self.repo = "OrgHide/openbox"
        self.api_key = os.environ.get("GITHUB_TOKEN") or os.environ.get("OPENROUTER_API_KEY")
        
        self.commands = {
            "status": self.repo_status,
            "commit": self.commit_changes,
            "push": self.push_changes,
            "pr": self.create_pr,
            "issue": self.create_issue,
            "deploy": self.deploy_actions,
            "security": self.check_security,
            "help": self.show_help
        }
    
    def repo_status(self):
        """Get repository status"""
        print("📊 Repository Status")
        print("=" * 40)
        
        # Git status
        result = subprocess.run("git status --porcelain", shell=True, capture_output=True, text=True)
        changes = result.stdout.strip().split('\n') if result.stdout else []
        
        print(f"Repository: {self.repo}")
        print(f"Changes: {len(changes)} files")
        for change in changes[:5]:
            print(f"   {change}")
        if len(changes) > 5:
            print(f"   ... and {len(changes)-5} more")
        
        # Branch info
        result = subprocess.run("git branch --show-current", shell=True, capture_output=True, text=True)
        print(f"Branch: {result.stdout.strip()}")
        
        # Remote info
        result = subprocess.run("git remote -v", shell=True, capture_output=True, text=True)
        print(f"Remote: {result.stdout.strip().split()[1]}")
    
    def commit_changes(self, message=None):
        """Commit changes to repository"""
        if not message:
            message = f"🤖 Auto-commit by GitHub Agent at {datetime.now()}"
        
        print("📝 Committing changes...")
        subprocess.run("git add .", shell=True)
        result = subprocess.run(f"git commit -m '{message}'", shell=True, capture_output=True, text=True)
        return result.stdout if result.stdout else "✅ Commit successful!"
    
    def push_changes(self):
        """Push changes to GitHub"""
        print("📤 Pushing to GitHub...")
        result = subprocess.run("git push origin main", shell=True, capture_output=True, text=True)
        return result.stdout if result.stdout else "✅ Push successful!"
    
    def create_pr(self, title, description="Auto-generated PR"):
        """Create a pull request"""
        print("🔀 Creating pull request...")
        
        # Create branch
        branch = f"auto-pr-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
        subprocess.run(f"git checkout -b {branch}", shell=True)
        subprocess.run("git add .", shell=True)
        subprocess.run(f"git commit -m 'Auto: {title}'", shell=True)
        subprocess.run(f"git push origin {branch}", shell=True)
        
        # Use gh to create PR
        result = subprocess.run(
            f"gh pr create --title '{title}' --body '{description}' --head {branch} --base main",
            shell=True, capture_output=True, text=True
        )
        return result.stdout if result.stdout else "✅ PR created!"
    
    def create_issue(self, title, body="Created by GitHub Agent"):
        """Create an issue"""
        print("📝 Creating issue...")
        result = subprocess.run(
            f"gh issue create --title '{title}' --body '{body}'",
            shell=True, capture_output=True, text=True
        )
        return result.stdout if result.stdout else "✅ Issue created!"
    
    def deploy_actions(self):
        """Trigger GitHub Actions deployment"""
        print("🚀 Triggering deployment...")
        result = subprocess.run(
            "gh workflow run deploy.yml --ref main",
            shell=True, capture_output=True, text=True
        )
        return "✅ Deployment triggered! Check: https://github.com/OrgHide/openbox/actions"
    
    def check_security(self):
        """Check repository security"""
        print("🔐 Checking security...")
        results = []
        
        # Check secrets in code
        result = subprocess.run(
            "grep -r 'password\\|secret\\|token\\|key' . --exclude-dir=.git --exclude-dir=.github --exclude-dir=deploy | grep -v '.md$'",
            shell=True, capture_output=True, text=True
        )
        if result.stdout:
            results.append(f"⚠️ Potential secrets found:\n{result.stdout[:500]}")
        else:
            results.append("✅ No secrets found in code")
        
        # Check dependencies
        results.append("📦 Dependencies: Check Dependabot alerts")
        
        return "\n".join(results)
    
    def show_help(self):
        """Show available commands"""
        print(f"""
🐙 {self.name} v{self.version}
========================================
Repository: {self.repo}
Available Commands:
  status          - Show repository status
  commit [message] - Commit changes
  push            - Push to GitHub
  pr              - Create pull request
  issue           - Create issue
  deploy          - Trigger deployment
  security        - Check security
  help            - Show this help

Example:
  agent.commit('Fix: Security update')
  agent.deploy()
========================================
""")

def main():
    agent = GitHubAgent()
    
    if len(sys.argv) < 2:
        print("🐙 OpenBox GitHub Agent")
        print("========================================")
        print("Usage:")
        print("  python github_agent.py status")
        print("  python github_agent.py commit 'message'")
        print("  python github_agent.py push")
        print("  python github_agent.py pr")
        print("  python github_agent.py issue")
        print("  python github_agent.py deploy")
        print("  python github_agent.py security")
        sys.exit(1)
    
    command = sys.argv[1]
    args = sys.argv[2] if len(sys.argv) > 2 else None
    
    if command in agent.commands:
        if args:
            result = agent.commands[command](args)
        else:
            result = agent.commands[command]()
        if result:
            print(result)
    else:
        print(f"❌ Unknown command: {command}")

if __name__ == "__main__":
    main()

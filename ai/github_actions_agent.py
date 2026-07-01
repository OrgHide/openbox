#!/usr/bin/env python3
"""
GitHub Actions AI Agent - Auto-trigger and monitor workflows
"""

import os
import sys
import json
import subprocess
import requests

class GitHubActionsAgent:
    def __init__(self):
        self.token = os.environ.get("GITHUB_TOKEN")
        self.repo = "OrgHide/openbox"
        
    def trigger_workflow(self, workflow="deploy.yml"):
        """Trigger a GitHub Actions workflow"""
        print(f"🚀 Triggering workflow: {workflow}")
        url = f"https://api.github.com/repos/{self.repo}/actions/workflows/{workflow}/dispatches"
        response = requests.post(
            url,
            headers={
                "Authorization": f"token {self.token}",
                "Accept": "application/vnd.github.v3+json"
            },
            json={"ref": "main"}
        )
        return response.status_code == 204
    
    def get_workflow_status(self, workflow="deploy.yml"):
        """Get workflow status"""
        print(f"📊 Getting status for: {workflow}")
        url = f"https://api.github.com/repos/{self.repo}/actions/workflows/{workflow}/runs"
        response = requests.get(
            url,
            headers={"Authorization": f"token {self.token}"}
        )
        return response.json()

def main():
    agent = GitHubActionsAgent()
    
    if len(sys.argv) < 2:
        print("Usage: python github_actions_agent.py [trigger|status]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "trigger":
        result = agent.trigger_workflow()
        print(f"✅ Workflow triggered: {result}")
    elif command == "status":
        result = agent.get_workflow_status()
        print(json.dumps(result, indent=2)[:500])
    else:
        print(f"❌ Unknown command: {command}")

if __name__ == "__main__":
    main()

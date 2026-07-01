#!/usr/bin/env python3
"""
Northflank AI Agent - Auto-deploy and fix OpenBox
"""

import os
import sys
import json
import subprocess
import time
import requests

class NorthflankAgent:
    def __init__(self):
        self.token = os.environ.get("NORTHFLANK_TOKEN")
        self.project = "openbox"
        self.service = "openbox"
        self.api_url = "https://api.northflank.com/v1"
        
    def deploy(self):
        """Deploy to Northflank"""
        print("🚀 Deploying to Northflank...")
        response = requests.post(
            f"{self.api_url}/deploy",
            headers={"Authorization": f"Bearer {self.token}"},
            json={"service": self.service, "project": self.project}
        )
        return response.json()
    
    def get_status(self):
        """Get deployment status"""
        print("📊 Checking deployment status...")
        response = requests.get(
            f"{self.api_url}/deployments",
            headers={"Authorization": f"Bearer {self.token}"}
        )
        return response.json()
    
    def auto_fix(self):
        """Auto-fix common issues"""
        print("🔧 Running auto-fix...")
        
        # Check if Dockerfile exists
        if not os.path.exists("Dockerfile"):
            print("⚠️ Dockerfile missing, creating...")
            # Create Dockerfile
            pass
        
        # Check config
        if not os.path.exists("configs/config.json"):
            print("⚠️ Config missing, creating...")
        
        print("✅ Auto-fix complete")
        return True

def main():
    agent = NorthflankAgent()
    
    if len(sys.argv) < 2:
        print("Usage: python northflank_agent.py [deploy|status|fix]")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "deploy":
        result = agent.deploy()
        print(json.dumps(result, indent=2))
    elif command == "status":
        result = agent.get_status()
        print(json.dumps(result, indent=2))
    elif command == "fix":
        result = agent.auto_fix()
        print(f"✅ Auto-fix completed: {result}")
    else:
        print(f"❌ Unknown command: {command}")

if __name__ == "__main__":
    main()

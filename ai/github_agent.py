#!/usr/bin/env python3
"""GitHub AI Agent - Manages repository operations"""

import os
import json
import subprocess
import sys

class GitHubAgent:
    def __init__(self):
        self.api_key = os.environ.get("OPENROUTER_API_KEY")
    
    def query(self, prompt):
        if not self.api_key:
            return self._local_commands(prompt)
        return self._ai_query(prompt)
    
    def _ai_query(self, prompt):
        import requests
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
                    {"role": "system", "content": "You are GitHub assistant. Help with git commands, PRs, issues, and repository management."},
                    {"role": "user", "content": prompt}
                ]
            }
        )
        return response.json()["choices"][0]["message"]["content"] if response.status_code == 200 else "⚠️ API Error"
    
    def _local_commands(self, prompt):
        commands = {
            "status": "git status",
            "commit": "git add . && git commit -m",
            "push": "git push origin main",
            "pull": "git pull origin main",
            "log": "git log --oneline -10"
        }
        for cmd, script in commands.items():
            if cmd in prompt.lower():
                result = subprocess.run(script, shell=True, capture_output=True, text=True)
                return f"📊 Result: {result.stdout[:500]}"
        return "💡 Available: status, commit, push, pull, log"

def main():
    agent = GitHubAgent()
    if len(sys.argv) > 1:
        print(agent.query(" ".join(sys.argv[1:])))
    else:
        print("Usage: python github_agent.py 'your question'")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""OpenList/AList AI Agent - Manages WebUI operations"""

import os
import json
import subprocess
import sys
import requests

class OpenListAgent:
    def __init__(self):
        self.api_key = os.environ.get("OPENROUTER_API_KEY")
        self.base_url = os.environ.get("ALIST_URL", "http://localhost:5244")
        self.token = os.environ.get("ALIST_TOKEN", "")
    
    def query(self, prompt):
        if not self.api_key:
            return self._local_commands(prompt)
        return self._ai_query(prompt)
    
    def _ai_query(self, prompt):
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json",
                "HTTP-Referer": "https://github.com/OrgHide/openbox"
            },
            json={
                "model": "meta-llama/llama-3.2-3b-instruct:free",
                "messages": [
                    {"role": "system", "content": "You are OpenList/AList WebUI assistant. Help with storage management, file operations, and WebUI configuration."},
                    {"role": "user", "content": prompt}
                ]
            }
        )
        return response.json()["choices"][0]["message"]["content"] if response.status_code == 200 else "⚠️ API Error"
    
    def _local_commands(self, prompt):
        commands = {
            "list": "curl -s -X GET http://localhost:5244/api/public/settings",
            "status": "curl -s -X GET http://localhost:5244/api/admin/storage/list",
            "about": "curl -s -X GET http://localhost:5244/api/public/about"
        }
        for cmd, script in commands.items():
            if cmd in prompt.lower():
                result = subprocess.run(script, shell=True, capture_output=True, text=True)
                return f"📊 Result: {result.stdout[:500]}"
        return "💡 Available: list, status, about"

def main():
    agent = OpenListAgent()
    if len(sys.argv) > 1:
        print(agent.query(" ".join(sys.argv[1:])))
    else:
        print("Usage: python openlist_agent.py 'your question'")

if __name__ == "__main__":
    main()

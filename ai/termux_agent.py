#!/usr/bin/env python3
"""Termux AI Agent - Manages Android terminal operations"""

import os
import json
import subprocess
import sys

class TermuxAgent:
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
                "model": "google/gemini-2.0-flash-lite-preview-02-05:free",
                "messages": [
                    {"role": "system", "content": "You are Termux Android assistant. Help with pkg commands, termux-api, storage, and Android operations."},
                    {"role": "user", "content": prompt}
                ]
            }
        )
        return response.json()["choices"][0]["message"]["content"] if response.status_code == 200 else "⚠️ API Error"
    
    def _local_commands(self, prompt):
        commands = {
            "storage": "df -h /storage/emulated/0",
            "battery": "termux-battery-status",
            "info": "termux-info",
            "wifi": "termux-wifi-connectioninfo"
        }
        for cmd, script in commands.items():
            if cmd in prompt.lower():
                result = subprocess.run(script, shell=True, capture_output=True, text=True)
                return f"📊 Result: {result.stdout[:500]}"
        return "💡 Available: storage, battery, info, wifi"

def main():
    agent = TermuxAgent()
    if len(sys.argv) > 1:
        print(agent.query(" ".join(sys.argv[1:])))
    else:
        print("Usage: python termux_agent.py 'your question'")

if __name__ == "__main__":
    main()

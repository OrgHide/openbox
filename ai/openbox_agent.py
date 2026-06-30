#!/usr/bin/env python3
"""
OpenBox AI Agent - Multi-Cloud Storage Assistant
Uses OpenRouter API with automatic model rotation (free/paid)
"""

import os
import json
import subprocess
import sys
from typing import Dict, List, Optional

class OpenBoxAgent:
    def __init__(self, config_path: str = "ai/openrouter_config.json"):
        """Initialize OpenBox AI Agent"""
        self.config = self._load_config(config_path)
        self.api_key = os.environ.get("OPENROUTER_API_KEY")
        if not self.api_key:
            print("⚠️ OPENROUTER_API_KEY not set. Using local mode.")
    
    def _load_config(self, path: str) -> Dict:
        """Load AI configuration"""
        try:
            with open(path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return {
                "models": {
                    "free": ["mistralai/mistral-7b-instruct:free"],
                    "paid": ["openai/gpt-4-turbo"]
                },
                "strategy": {"primary": "free", "fallback": "paid"}
            }
    
    def _get_model(self) -> str:
        """Get appropriate model based on strategy"""
        strategy = self.config.get("strategy", {})
        primary = strategy.get("primary", "free")
        
        models = self.config.get("models", {})
        if primary == "free" and models.get("free"):
            return models["free"][0]
        elif primary == "paid" and models.get("paid"):
            return models["paid"][0]
        
        # Fallback to any available model
        all_models = models.get("free", []) + models.get("paid", [])
        return all_models[0] if all_models else "mistralai/mistral-7b-instruct:free"
    
    def query(self, prompt: str, context: str = "") -> str:
        """Query AI agent"""
        if not self.api_key:
            return self._local_fallback(prompt)
        
        model = self._get_model()
        
        import requests
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json",
                "HTTP-Referer": "https://github.com/OrgHide/openbox",
                "X-Title": "OpenBox AI Agent"
            },
            json={
                "model": model,
                "messages": [
                    {"role": "system", "content": self.config.get("system_prompt", "You are an AI assistant.")},
                    {"role": "user", "content": f"{context}\n\n{prompt}"}
                ],
                "temperature": 0.7
            }
        )
        
        if response.status_code == 200:
            return response.json()["choices"][0]["message"]["content"]
        else:
            return f"⚠️ API Error: {response.status_code} - {response.text}"
    
    def _local_fallback(self, prompt: str) -> str:
        """Local fallback when no API key is available"""
        commands = {
            "list": "rclone ls openbox:/ --max-depth 1",
            "status": "~/openbox/scripts/status.sh",
            "backup": "~/openbox/backup_system.sh",
            "sync": "~/openbox/sync.sh"
        }
        
        for cmd, script in commands.items():
            if cmd in prompt.lower():
                result = subprocess.run(script, shell=True, capture_output=True, text=True)
                return f"📊 Result: {result.stdout[:500]}"
        
        return f"💡 I can help you with: {', '.join(commands.keys())}\n\nRun: export OPENROUTER_API_KEY=your_key for AI assistance."
    
    def organize(self, path: str = "openbox:/") -> str:
        """Organize files in warehouse"""
        return self.query(
            f"Organize files at {path} by type, date, and relevance",
            f"Current files: {subprocess.run(f'rclone ls {path} --max-depth 2', shell=True, capture_output=True, text=True).stdout[:1000]}"
        )
    
    def analyze(self, path: str = "openbox:/") -> str:
        """Analyze storage usage"""
        return self.query(
            f"Analyze storage at {path}",
            f"Storage info: {subprocess.run(f'rclone about {path}', shell=True, capture_output=True, text=True).stdout}"
        )
    
    def suggest(self, path: str = "openbox:/") -> str:
        """Suggest optimizations"""
        return self.query(
            f"Suggest optimizations for {path}",
            "Consider: deduplication, archiving old files, compression, syncing across clouds"
        )

def main():
    agent = OpenBoxAgent()
    
    if len(sys.argv) < 2:
        print("Usage: python openbox_agent.py [command] [args]")
        print("Commands: organize, analyze, suggest, query \"your question\"")
        print("Example: python openbox_agent.py organize openbox:/Documents")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "organize":
        path = sys.argv[2] if len(sys.argv) > 2 else "openbox:/"
        print(agent.organize(path))
    elif command == "analyze":
        path = sys.argv[2] if len(sys.argv) > 2 else "openbox:/"
        print(agent.analyze(path))
    elif command == "suggest":
        path = sys.argv[2] if len(sys.argv) > 2 else "openbox:/"
        print(agent.suggest(path))
    elif command == "query":
        prompt = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""
        print(agent.query(prompt))
    else:
        print(f"❌ Unknown command: {command}")
        print("Available: organize, analyze, suggest, query")

if __name__ == "__main__":
    main()

# LLMChatBridge (WIP)

```
 ________            __    ____        __   __               
/_  __/ /  ___   __ / /__ / / /_ __   / /  / /__ ___ _  ___ _
 / / / _ \/ -_) / // / -_) / / // /  / /__/ / _ `/  ' \/ _ `/
/_/ /_//_/\__/  \___/\__/_/_/\_, /  /____/_/\_,_/_/_/_/\_,_/ 
                            /___/                            

     Local Ollama LLM RAG chat interface for Jellyfin
```

## Overview

**LLMChatBridge** is a Jellyfin plugin that enables chat-based interactions with a local or remote LLM (e.g., Ollama). It connects Jellyfin users to AI-powered media recommendations and answers via a configurable chat UI backed by one or more LLM endpoints.

- Supports **primary** and **secondary** LLM endpoints
- Customize model, system prompt, and timeout behavior
- Designed to work with Ollama or (via a future project) compatible HTTP chat APIs

---

## Features (WIP)

- [x] Plugin config UI using Jellyfin styling
- [x] Admin-editable system prompt
- [x] Primary/Secondary LLM URL & model config for both
- [ ] Investigate : Chat interface in Jellyfin UI
- [ ] Investigate : Per-user or per-session model selection
- [ ] Investigate : WebSocket/streaming support for live response
- [ ] Investigate : Response formatting with bullet lists and recommendations
- [ ] Investigate : Rate-limiting and concurrency control via dequeue
- [ ] Investigate : Privacy aware logging and analytics

---

## Configuration

To configure:

1. Open **Dashboard → Plugins → LLMChatBridge**
2. Enter your:
   - **Primary URL**: e.g. `http://localhost:11434`
   - **Primary Model**: e.g. `llama3.2:3b`
   - **Secondary Model**: e.g. `llama3.2:1b`
   - **System Prompt**: Optional, fallback to default persona
   - Optional: Secondary endpoint, and prompt
3. Save the form

---

## Default System Prompt

If no custom prompt is set, the following will be used:

> You are a media expert. You specialise in recommending Movies, TV, Music, Audiobooks, Books and Comics. Be friendly and helpful. Pay attention to user queries about titles, genres, tags, release dates/years, actors, directors and plots. Your replies are ideally a little chatty and bullet point lists of suggestions.

---

## Development

Create .env

```bash
cp .env.example .env
```

Edit .env & set to the custom-setup-by-you folder that your jellyfin uses for plugins

```
PLUGIN_MOUNT=<your path to>/jellyfin-plugins
```

To build:

```bash
chmod +x ./build.sh
./build.sh
```
or for powershell users
```
./build.ps1
```

* Automatic deployment happens
* Restart your Jellyfin Server to pick up the new deployment


---

## The wider eco system

This plugin is 1 of 3 components designed to add a RAG based prompt to Jellyfin that's an expert at your media collection and can make reccomendations to users via chat, ...or just chit chat about anything at all

Reply sophistication : Prompt replies will reflect the size of the model you can run anywhere on your local LAN

Python fuzzywuzzy will attempt to match chat replies to local media 

### The 3 components of the eco system 

1. A custom cook of jellyfin-web

   https://github.com/NTaylor71/jellyfin-web/tree/custard-brand-jelly-chat

   * Adds a chat window to jellyfin that plugins can utilize

   		* /src/components/chatBox/chatBox.js
   		* /src/components/chatBox/chatBox.template.html

   * Chat window works on any client, Smart TVs too

   #TODO : Remove custom branding

2. THIS plugin

	* Contains your local admin secrets to talk to one or more Ollama servers

	* Secrets are set via plugin config page via Jellyfin UI

	* Chat access is added for all users


3. A docker image called : Jellyfin.Llm.Chat

	* Contains : Ollama, Python 3.12 + Langchain, postgres/redis

	* Chat request message are async-queued

	* Queue proccessed via python/Langchain that utilize RAG

	* RAG data is provided via a schedule in Jellyfin from THIS plugin

		* Jellyfin's db is thus RAG'ified by LangChain

	* Python uses fuzzywuzzy to spot known media content in replies from ollama-LancgChain and present them as Jellyfin links for users to select

	* The plugin provides settings for 2 Jelly-Ollama servers, Primary and Secondary

		* Primary : eg A fast sometime-on desktop with a large GPU

			* can run bigger models

		* Secondary : eg An always on machine (NAS) 

			* likely can run only small models


---

## Status

🚧 Work in Progress  
🧪 Experimental API usage  
🔒 Local only (no public internet access required)

---


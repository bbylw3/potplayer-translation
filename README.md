# PotPlayer OpenAI API Translation Script

> This project is a modified version of [potplayer-translation-openaiapi](https://github.com/Fung-2025/potplayer-translation-openaiapi) with enhanced support for multiple API services.

## Overview
This script enables real-time subtitle translation in PotPlayer using various AI API services, including OpenAI API, OpenRouter, Zhipu AI (智谱AI), and free.v36.cm.

## Features
- Supports multiple AI API services:
  - OpenAI compatible APIs
  - OpenRouter
  - Zhipu AI (智谱AI)
  - free.v36.cm
- Automatic API URL correction
- Detailed error messages for troubleshooting
- Customizable translation prompts

## Usage Instructions

### General Format
```
Model&API URL: [model_name]&[api_url]
API Key: [your_api_key]
```

### For OpenAI Compatible APIs
```
Model&API URL: gpt-3.5-turbo&https://api.openai.com/v1
API Key: sk-xxxxxxxxxxxxxxxxxxxxxxxx
```

### For OpenRouter
```
Model&API URL: gpt-3.5-turbo&https://openrouter.ai/api/v1
API Key: sk-or-xxxxxxxxxxxxxxxxxxxxxxxx
```
Note: The script will automatically add "openai/" prefix to GPT models if needed.

### For Zhipu AI (智谱AI)
```
Model&API URL: glm-4-flash&https://open.bigmodel.cn/api/paas/v4
API Key: [your_zhipu_api_key]
```
Note: glm-4-flash is recommended as it's free to use.

### For free.v36.cm
```
Model&API URL: gpt-4o-mini&https://free.v36.cm/v1
API Key: [your_free_v36_api_key]
```

## Troubleshooting
- If you receive HTML responses instead of JSON, check if your API URL is correct
- For OpenRouter, ensure your model name includes the provider prefix (e.g., "openai/gpt-3.5-turbo")
- For Zhipu AI (智谱AI), use the recommended model "glm-4-flash" for free access
- Check that your API key is correctly formatted and valid

## Installation
1. Download the script file "SubtitleTranslate - OpenAI API.as"
2. Place it in PotPlayer's extension directory:
   - Typically: `C:\Program Files\DAUM\PotPlayer\Extension\Subtitle\Translate`
3. Restart PotPlayer
4. Enable subtitle translation in PotPlayer settings

---

# PotPlayer OpenAI API 翻译脚本

## 概述
此脚本使用各种AI API服务为PotPlayer提供实时字幕翻译功能，包括OpenAI API、OpenRouter、智谱AI和free.v36.cm。

## 特点
- 支持多种AI API服务：
  - OpenAI兼容API
  - OpenRouter
  - 智谱AI
  - free.v36.cm
- 自动API URL修正
- 详细的错误信息帮助排查问题
- 可自定义翻译提示词

## 使用说明

### 通用格式
```
模型&API URL: [模型名称]&[api_url]
API密钥: [你的api密钥]
```

### OpenAI兼容API
```
模型&API URL: gpt-3.5-turbo&https://api.openai.com/v1
API密钥: sk-xxxxxxxxxxxxxxxxxxxxxxxx
```

### OpenRouter
```
模型&API URL: gpt-3.5-turbo&https://openrouter.ai/api/v1
API密钥: sk-or-xxxxxxxxxxxxxxxxxxxxxxxx
```
注意：脚本会自动为GPT模型添加"openai/"前缀（如有需要）。

### 智谱AI
```
模型&API URL: glm-4-flash&https://open.bigmodel.cn/api/paas/v4
API密钥: [你的智谱AI密钥]
```
注意：推荐使用glm-4-flash模型，它是免费的。

### free.v36.cm
```
模型&API URL: gpt-4o-mini&https://free.v36.cm/v1
API密钥: [你的free.v36.cm密钥]
```

## 故障排除
- 如果收到HTML响应而不是JSON，请检查API URL是否正确
- 对于OpenRouter，确保模型名称包含提供商前缀（例如："openai/gpt-3.5-turbo"）
- 对于智谱AI，使用推荐的"glm-4-flash"模型获取免费访问
- 检查API密钥格式是否正确且有效

## 安装方法
1. 下载脚本文件"SubtitleTranslate - OpenAI API.as"
2. 将其放置在PotPlayer的扩展目录中：
   - 通常位置：`C:\Program Files\DAUM\PotPlayer\Extension\Subtitle\Translate`
3. 重启PotPlayer
4. 在PotPlayer设置中启用字幕翻译

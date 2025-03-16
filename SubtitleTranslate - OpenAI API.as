/*
	real time subtitle translate for PotPlayer using OpenAI API
	https://platform.openai.com/docs/api-reference
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 											-> get title for UI
// string GetVersion()											-> get version for manage
// string GetDesc()												-> get detail information
// string GetLoginTitle()										-> get title for login dialog
// string GetLoginDesc()										-> get desc for login dialog
// string GetUserText()											-> get user text for login dialog
// string GetPasswordText()										-> get password text for login dialog
// string ServerLogin(string User, string Pass)							-> login
// string ServerLogout()										-> logout
//------------------------------------------------------------------------------------------------
// array<string> GetSrcLangs() 										-> get source language
// array<string> GetDstLangs() 										-> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang) 	-> do translate !!

array<string> LangTable = 
{
	"af",
	"sq",
	"am",
	"ar",
	"hy",
	"az",
	"eu",
	"be",
	"bn",
	"bs",
	"bg",
	"my",
	"ca",
	"ceb",
	"ny",
	"zh",
	"zh-CN",
	"zh-TW",
	"co",
	"hr",
	"cs",
	"da",
	"nl",
	"en",
	"eo",
	"et",
	"tl",
	"fi",
	"fr",
	"fy",
	"gl",
	"ka",
	"de",
	"el",
	"gu",
	"ht",
	"ha",
	"haw",
	"iw",
	"hi",
	"hmn",
	"hu",
	"is",
	"ig",
	"id",
	"ga",
	"it",
	"ja",
	"jw",
	"kn",
	"kk",
	"km",
	"ko",
	"ku",
	"ky",
	"lo",
	"la",
	"lv",
	"lt",
	"lb",
	"mk",
	"ms",
	"mg",
	"ml",
	"mt",
	"mi",
	"mr",
	"mn",
	"my",
	"ne",
	"no",
	"ps",
	"fa",
	"pl",
	"pt",
	"pa",
	"ro",
	"romanji",
	"ru",
	"sm",
	"gd",
	"sr",
	"st",
	"sn",
	"sd",
	"si",
	"sk",
	"sl",
	"so",
	"es",
	"su",
	"sw",
	"sv",
	"tg",
	"ta",
	"te",
	"th",
	"tr",
	"uk",
	"ur",
	"uz",
	"vi",
	"cy",
	"xh",
	"yi",
	"yo",
	"zu"
};

string UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36";

string GetTitle()
{
	return "{$CP949=OpenAI API$}{$CP950=OpenAI API$}{$CP0=OpenAI API$}";
}

string GetVersion()
{
	return "1";
}

string GetDesc()
{
	return "<a href=\"https://platform.openai.com/docs/api-reference\">https://platform.openai.com/docs/api-reference</a>";
}

string GetLoginTitle()
{
	return "Input OpenAI Model & API Settings";
}

string GetLoginDesc()
{
	return "Input model&api_url and API key";
}

string GetUserText()
{
	return "Model&API URL:";
}

string GetPasswordText()
{
	return "API Key:";
}

string model;
string api_url;
string api_key;

array<string> split(string str, string delimiter) 
{
	array<string> parts;
	int startPos = 0;
	while (true) {
		int index = str.findFirst(delimiter, startPos);
		if (index == -1) {
			parts.insertLast(str.substr(startPos));
			break;
		}
		else {
			parts.insertLast(str.substr(startPos, index - startPos));
			startPos = index + delimiter.length();
		}
	}
	return parts;
}

string ServerLogin(string User, string Pass)
{
	array<string> settings = split(User, "&");
	if (settings.length() != 2) return "fail: invalid model&api_url format";
	
	model = settings[0];
	api_url = settings[1];
	api_key = Pass;
	
	// 检查URL格式
	if (api_url.findFirst("http") != 0) {
		return "fail: API URL必须以http://或https://开头";
	}
	
	// 自动修正API URL
	// 如果URL是网站而不是API端点，尝试添加正确的路径
	if (api_url.findFirst("free.v36.cm") >= 0) {
		// 这是一个已知的免费API网站，需要特定的端点
		if (api_url.findFirst("/v1/chat/completions") < 0) {
			if (api_url.findLast("/") == api_url.length() - 1) {
				api_url += "v1/chat/completions";
			} else {
				api_url += "/v1/chat/completions";
			}
		}
	}
	else if (api_url.findFirst("openrouter.ai") >= 0) {
		// OpenRouter API需要特定的端点
		// 修正：确保使用正确的OpenRouter API端点
		if (api_url.findFirst("/api/v1/chat/completions") < 0) {
			// 清除可能的路径
			int lastSlash = api_url.findLast("/");
			if (lastSlash > 8) { // 确保不会删除http://中的斜杠
				api_url = api_url.substr(0, lastSlash);
				// 再次检查是否还有路径
				lastSlash = api_url.findLast("/");
				if (lastSlash > 8 && api_url.substr(lastSlash).findFirst("openrouter.ai") < 0) {
					api_url = api_url.substr(0, lastSlash);
				}
			}
			
			// 添加正确的路径
			if (api_url.findLast("/") == api_url.length() - 1) {
				api_url += "api/v1/chat/completions";
			} else {
				api_url += "/api/v1/chat/completions";
			}
		}
	}
	else if (api_url.findFirst("open.bigmodel.cn") >= 0) {
		// 智谱AI API需要特定的端点
		// 修正：确保使用正确的智谱AI API端点
		if (api_url.findFirst("/api/paas/v4") < 0) {
			// 清除可能的路径
			int lastSlash = api_url.findLast("/");
			if (lastSlash > 8) { // 确保不会删除http://中的斜杠
				api_url = api_url.substr(0, lastSlash);
				// 再次检查是否还有路径
				lastSlash = api_url.findLast("/");
				if (lastSlash > 8 && api_url.substr(lastSlash).findFirst("bigmodel.cn") < 0) {
					api_url = api_url.substr(0, lastSlash);
				}
			}
			
			// 添加正确的路径
			if (api_url.findLast("/") == api_url.length() - 1) {
				api_url += "api/paas/v4";
			} else {
				api_url += "/api/paas/v4";
			}
		}
	}
	else if (api_url.findFirst("/v1/chat/completions") < 0 && 
	         api_url.findFirst("/v1/completions") < 0 && 
	         api_url.findFirst("/api/chat") < 0) {
		// 一般的OpenAI兼容API，添加标准路径
		if (api_url.findLast("/") == api_url.length() - 1) {
			api_url += "v1/chat/completions";
		} else {
			api_url += "/v1/chat/completions";
		}
	}
	
	if (model.empty() || api_url.empty() || api_key.empty()) return "fail";
	return "200 ok";
}

void ServerLogout()
{
	api_key = "";
}

array<string> GetSrcLangs()
{
	array<string> ret = LangTable;
	
	ret.insertAt(0, ""); // empty is auto
	return ret;
}

array<string> GetDstLangs()
{
	array<string> ret = LangTable;
	return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
	if (api_key.empty()) return "错误: API密钥未设置";
	if (Text.empty()) return "";
	
	// 构建请求URL和头部
	string url = api_url;
	
	// 检测不同的API服务
	bool isFreeV36 = (url.findFirst("free.v36.cm") >= 0);
	bool isOpenRouter = (url.findFirst("openrouter.ai") >= 0);
	bool isBigModel = (url.findFirst("open.bigmodel.cn") >= 0);
	
	// 构建基本请求头
	string SendHeader = "Content-Type: application/json\r\n";
	SendHeader += "Accept: application/json\r\n";
	
	// 根据不同API服务添加不同的认证头
	if (isOpenRouter) {
		// OpenRouter需要特定的请求头
		SendHeader += "HTTP-Referer: https://potplayer.tv\r\n";
		SendHeader += "X-Title: PotPlayer Subtitle Translate\r\n";
		// OpenRouter使用Bearer认证
		if (api_key.findFirst("Bearer ") != 0 && api_key.findFirst("bearer ") != 0) {
			SendHeader += "Authorization: Bearer " + api_key + "\r\n";
		} else {
			SendHeader += "Authorization: " + api_key + "\r\n";
		}
	} 
	else if (isBigModel) {
		// 智谱AI使用不同的认证方式
		// 智谱AI可能需要API Key作为完整的认证头
		if (api_key.findFirst("Bearer ") == 0 || api_key.findFirst("bearer ") == 0 || 
		    api_key.findFirst("Basic ") == 0 || api_key.findFirst("basic ") == 0 ||
		    api_key.findFirst("Apikey ") == 0 || api_key.findFirst("apikey ") == 0) {
			SendHeader += "Authorization: " + api_key + "\r\n";
		} else {
			SendHeader += "Authorization: Bearer " + api_key + "\r\n";
		}
	}
	else {
		// 标准OpenAI兼容API
		if (api_key.findFirst("Bearer ") != 0 && api_key.findFirst("bearer ") != 0) {
			SendHeader += "Authorization: Bearer " + api_key + "\r\n";
		} else {
			SendHeader += "Authorization: " + api_key + "\r\n";
		}
	}
	
	// 对于free.v36.cm，添加更多请求头
	if (isFreeV36) {
		SendHeader += "Origin: https://free.v36.cm\r\n";
		SendHeader += "Referer: https://free.v36.cm/\r\n";
	}
	
	// 构建提示词和文本
	string prompt = "";
	if (SrcLang != "auto" && SrcLang != "") {
		prompt = "将以下文本从" + SrcLang + "翻译成" + DstLang + "。只输出翻译结果，不要添加任何解释: ";
	} else {
		prompt = "将以下文本翻译成" + DstLang + "。只输出翻译结果，不要添加任何解释: ";
	}
	
	// 转义文本用于JSON
	string escapedText = Text;
	escapedText.replace("\\", "\\\\");
	escapedText.replace("\"", "\\\"");
	escapedText.replace("\n", "\\n");
	escapedText.replace("\r", "\\r");
	escapedText.replace("\t", "\\t");
	
	// 构建请求体 - 根据不同API服务使用不同格式
	string Post = "";
	
	if (isBigModel) {
		// 智谱AI的请求体格式
		Post = "{\"model\":\"" + model + "\",";
		Post += "\"messages\":[";
		Post += "{\"role\":\"system\",\"content\":\"你是一个直接的翻译器。将输入的文本准确地翻译成指定的目标语言。不要添加任何解释、注释或额外内容。只返回翻译后的文本。\"},";
		Post += "{\"role\":\"user\",\"content\":\"" + prompt + escapedText + "\"}],";
		Post += "\"temperature\":0.2,";
		Post += "\"stream\":false}";
		
		// 智谱AI需要在URL中添加chat/completions
		if (url.findFirst("/chat/completions") < 0) {
			if (url.findLast("/") == url.length() - 1) {
				url += "chat/completions";
			} else {
				url += "/chat/completions";
			}
		}
	}
	else if (isOpenRouter) {
		// OpenRouter的请求体格式
		// 确保模型名称正确（如果没有提供商前缀，添加默认的openai/）
		string routerModel = model;
		if (routerModel.findFirst("/") < 0 && 
		    routerModel.findFirst("gpt-") >= 0) {
			routerModel = "openai/" + routerModel;
		}
		
		Post = "{\"model\":\"" + routerModel + "\",";
		Post += "\"messages\":[";
		Post += "{\"role\":\"system\",\"content\":\"你是一个直接的翻译器。将输入的文本准确地翻译成指定的目标语言。不要添加任何解释、注释或额外内容。只返回翻译后的文本。\"},";
		Post += "{\"role\":\"user\",\"content\":\"" + prompt + escapedText + "\"}],";
		Post += "\"temperature\":0.2,";
		Post += "\"max_tokens\":2048,";
		Post += "\"stream\":false}";
	}
	else if (isFreeV36) {
		// free.v36.cm的请求体格式
		Post = "{\"model\":\"" + model + "\",";
		Post += "\"messages\":[";
		Post += "{\"role\":\"system\",\"content\":\"你是一个直接的翻译器。将输入的文本准确地翻译成指定的目标语言。不要添加任何解释、注释或额外内容。只返回翻译后的文本。\"},";
		Post += "{\"role\":\"user\",\"content\":\"" + prompt + escapedText + "\"}],";
		Post += "\"temperature\":0.2,";
		Post += "\"max_tokens\":2048,";
		Post += "\"stream\":false}";
	}
	else {
		// 标准OpenAI兼容API的请求体格式
		Post = "{\"model\":\"" + model + "\",";
		Post += "\"messages\":[";
		Post += "{\"role\":\"system\",\"content\":\"你是一个直接的翻译器。将输入的文本准确地翻译成指定的目标语言。不要添加任何解释、注释或额外内容。只返回翻译后的文本。\"},";
		Post += "{\"role\":\"user\",\"content\":\"" + prompt + escapedText + "\"}],";
		Post += "\"temperature\":0.2}";
	}
	
	// 发送请求
	string ret = "";
	uintptr http = HostOpenHTTP(url, UserAgent, SendHeader, Post);
	if (http != 0)
	{
		string json = HostGetContentHTTP(http);
		HostCloseHTTP(http);
		
		if (json.empty()) {
			return "错误: 服务器返回空响应";
		}
		
		// 检查是否返回了HTML
		if (json.findFirst("<html") >= 0 || json.findFirst("<body") >= 0 || 
		    json.findFirst("<!doctype") >= 0 || json.findFirst("<head") >= 0 || 
		    json.findFirst("<meta") >= 0 || json.findFirst("<script") >= 0 || 
		    json.findFirst("<link") >= 0 || json.findFirst("<title") >= 0) {
			
			// 根据不同API服务提供特定的错误信息
			if (isFreeV36) {
				return "错误: free.v36.cm返回了HTML页面而不是API响应。请确保使用正确的API端点和密钥。";
			} else if (isOpenRouter) {
				return "错误: OpenRouter返回了HTML页面而不是API响应。请确保使用正确的API密钥和模型名称。OpenRouter需要完整的模型名称，如'openai/gpt-3.5-turbo'。\n当前URL: " + url + "\n当前模型: " + model;
			} else if (isBigModel) {
				return "错误: 智谱AI返回了HTML页面而不是API响应。请确保使用正确的API密钥和模型名称。\n当前URL: " + url + "\n当前模型: " + model;
			}
			
			// 返回更详细的错误信息，包括部分响应内容
			return "错误: 服务器返回了HTML页面而不是JSON。请检查API URL是否正确。\n当前URL: " + url + "\n当前模型: " + model + "\n\n响应片段: " + json.substr(0, 200);
		}
		
		// 检查是否是JSON格式
		if (json.findFirst("{") < 0 || json.findFirst("}") < 0) {
			// 不是JSON格式，可能是纯文本或其他格式
			if (json.length() < 500) {
				return "错误: 响应不是JSON格式: " + json;
			} else {
				return "错误: 响应不是JSON格式: " + json.substr(0, 500) + "...";
			}
		}
		
		// 检查是否有错误消息
		if (json.findFirst("\"error\"") >= 0 || json.findFirst("\"status\":4") >= 0 || json.findFirst("\"status\":5") >= 0) {
			// 尝试提取错误消息
			string errorMsg = "";
			
			// 尝试提取标准错误消息
			int messageStart = json.findFirst("\"message\"");
			if (messageStart < 0) {
				messageStart = json.findFirst("\"msg\"");
			}
			
			if (messageStart >= 0) {
				messageStart = json.findFirst(":", messageStart);
				if (messageStart >= 0) {
					messageStart = json.findFirst("\"", messageStart);
					if (messageStart >= 0) {
						int messageEnd = json.findFirst("\"", messageStart + 1);
						if (messageEnd >= 0) {
							errorMsg = json.substr(messageStart + 1, messageEnd - messageStart - 1);
						}
					}
				}
			}
			
			// 如果找到了错误消息
			if (!errorMsg.empty()) {
				if (isBigModel) {
					return "智谱AI错误: " + errorMsg + "\n请确认模型名称正确，推荐使用glm-4-flash模型（免费）";
				} else if (isOpenRouter) {
					return "OpenRouter错误: " + errorMsg + "\n请确认模型名称正确，应包含提供商前缀，如: openai/gpt-3.5-turbo";
				} else {
					return "API错误: " + errorMsg;
				}
			}
			
			// 如果没有找到具体错误消息，返回通用错误
			return "API错误: 服务器返回了错误，但无法提取具体错误信息。请检查API密钥和模型名称是否正确。";
		}
		
		// 尝试提取翻译内容 - 根据不同API服务处理不同的响应格式
		int contentStart = -1;
		
		if (isBigModel) {
			// 智谱AI的响应格式可能不同
			contentStart = json.findFirst("\"content\"");
			if (contentStart < 0) {
				contentStart = json.findFirst("\"response\"");
				if (contentStart < 0) {
					contentStart = json.findFirst("\"result\"");
					if (contentStart < 0) {
						contentStart = json.findFirst("\"generated_text\"");
					}
				}
			}
		} 
		else if (isOpenRouter) {
			// OpenRouter的响应格式
			contentStart = json.findFirst("\"content\"");
			if (contentStart < 0) {
				contentStart = json.findFirst("\"message\"");
				if (contentStart >= 0) {
					// 如果找到message字段，可能需要进一步查找content
					int tempStart = json.findFirst("\"content\"", contentStart);
					if (tempStart >= 0) {
						contentStart = tempStart;
					}
				}
			}
		}
		else {
			// 标准OpenAI格式
			contentStart = json.findFirst("\"content\"");
			if (contentStart < 0) {
				contentStart = json.findFirst("\"text\"");
				if (contentStart < 0) {
					contentStart = json.findFirst("\"message\"");
					if (contentStart < 0) {
						contentStart = json.findFirst("\"translation\"");
					}
				}
			}
		}
		
		if (contentStart >= 0) {
			contentStart = json.findFirst(":", contentStart);
			if (contentStart >= 0) {
				contentStart = json.findFirst("\"", contentStart);
				if (contentStart >= 0) {
					int contentEnd = json.findFirst("\"", contentStart + 1);
					while (contentEnd > 0 && json.substr(contentEnd - 1, 1) == "\\") {
						contentEnd = json.findFirst("\"", contentEnd + 1);
					}
					
					if (contentEnd >= 0) {
						ret = json.substr(contentStart + 1, contentEnd - contentStart - 1);
						ret.replace("\\\"", "\"");
						ret.replace("\\\\", "\\");
						ret.replace("\\n", "\n");
						ret.replace("\\r", "\r");
						ret.replace("\\t", "\t");
					}
				}
			}
		}
		
		// 如果仍然没有结果，返回原始JSON（限制长度）
		if (ret.empty()) {
			if (json.length() > 500) {
				ret = "无法解析响应: " + json.substr(0, 500) + "...";
			} else {
				ret = "无法解析响应: " + json;
			}
		}
	}
	else
	{
		// 根据不同API服务提供特定的错误信息
		if (isFreeV36) {
			return "错误: 无法连接到free.v36.cm API服务器。该服务可能不稳定或已更改。";
		} else if (isOpenRouter) {
			return "错误: 无法连接到OpenRouter API服务器。请检查API URL和网络连接。\n当前URL: " + url + "\n当前模型: " + model + "\n\n提示: OpenRouter模型名称应包含提供商前缀，如'openai/gpt-3.5-turbo'";
		} else if (isBigModel) {
			return "错误: 无法连接到智谱AI API服务器。请检查API URL和网络连接。\n当前URL: " + url + "\n当前模型: " + model + "\n\n提示: 智谱AI推荐使用glm-4-flash模型，这是免费的。其他常用模型有glm-4, glm-3-turbo";
		}
		
		ret = "错误: 无法连接到API服务器，请检查API URL是否正确。\n当前URL: " + url + "\n当前模型: " + model;
	}
	
	SrcLang = "UTF8";
	DstLang = "UTF8";
	return ret;
}

#!/usr/bin/env python3
"""
Simple MCP server for web search using DuckDuckGo
No API keys required - completely free!
"""

import json
import sys
import time
import urllib.request
import urllib.parse
from html.parser import HTMLParser
import re

class DuckDuckGoParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.results = []
        self.current_result = {}
        self.in_result = False
        self.in_title = False
        self.in_snippet = False
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        # Look for search result divs
        if tag == 'div' and 'class' in attrs_dict:
            if 'result' in attrs_dict['class'] or 'web-result' in attrs_dict['class']:
                self.in_result = True
                self.current_result = {}
                
        # Look for title links
        elif self.in_result and tag == 'a' and 'href' in attrs_dict:
            if not self.current_result.get('url'):
                self.current_result['url'] = attrs_dict['href']
                self.in_title = True
                
        # Look for snippet divs
        elif self.in_result and tag == 'div' and 'class' in attrs_dict:
            if 'snippet' in attrs_dict['class'] or 'result__snippet' in attrs_dict['class']:
                self.in_snippet = True
                
    def handle_data(self, data):
        if self.in_title:
            self.current_result['title'] = data.strip()
        elif self.in_snippet:
            self.current_result['snippet'] = data.strip()
            
    def handle_endtag(self, tag):
        if tag == 'div' and self.in_result:
            if self.current_result.get('title') and self.current_result.get('url'):
                self.results.append(self.current_result)
            self.in_result = False
            self.current_result = {}
        elif tag == 'a' and self.in_title:
            self.in_title = False
        elif tag == 'div' and self.in_snippet:
            self.in_snippet = False

def search_web(query):
    """Search DuckDuckGo and return results"""
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote(query)}"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        # Retry logic for network requests
        for attempt in range(3):
            try:
                req = urllib.request.Request(url, headers=headers)
                with urllib.request.urlopen(req, timeout=15) as response:
                    html = response.read().decode('utf-8', errors='ignore')
                break
            except Exception as e:
                if attempt == 2:  # Last attempt
                    raise e
                time.sleep(1)  # Wait 1 second before retry
        
        parser = DuckDuckGoParser()
        parser.feed(html)
        
        # If no results from HTML parsing, try regex fallback
        if not parser.results:
            # Simple regex to find result patterns
            result_pattern = r'<a[^>]*class="result__a"[^>]*href="([^"]*)"[^>]*>([^<]*)</a>'
            matches = re.findall(result_pattern, html)
            
            for url, title in matches[:5]:
                if url.startswith('/'):
                    url = 'https://duckduckgo.com' + url
                parser.results.append({
                    'title': title.strip(),
                    'url': url,
                    'snippet': 'Search result from DuckDuckGo'
                })
        
        return {
            "results": parser.results[:10],
            "query": query,
            "count": len(parser.results)
        }
            
    except Exception as e:
        return {
            "error": f"Search failed: {str(e)}",
            "query": query,
            "results": []
        }

def main():
    """MCP server main loop"""
    
    import signal
    
    def timeout_handler(signum, frame):
        raise TimeoutError("MCP operation timed out")
    
    signal.signal(signal.SIGALRM, timeout_handler)
    
    while True:
        try:
            # Set timeout for readline
            signal.alarm(30)  # 30 second timeout
            
            line = sys.stdin.readline()
            if not line:
                break
                
            signal.alarm(0)  # Cancel timeout
            request = json.loads(line.strip())
            
            if request.get("method") == "initialize":
                response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id"),
                    "result": {
                        "protocolVersion": "2024-11-05",
                        "capabilities": {
                            "tools": {}
                        },
                        "serverInfo": {
                            "name": "simple-search",
                            "version": "1.0.0"
                        }
                    }
                }
                print(json.dumps(response))
                sys.stdout.flush()
                
            elif request.get("method") == "tools/list":
                response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id"),
                    "result": {
                        "tools": [{
                            "name": "search_web",
                            "description": "Search the web for current information (local, free, no API key)",
                            "inputSchema": {
                                "type": "object",
                                "properties": {
                                    "query": {
                                        "type": "string",
                                        "description": "Search query"
                                    }
                                },
                                "required": ["query"]
                            }
                        }]
                    }
                }
                print(json.dumps(response))
                sys.stdout.flush()
                
            elif request.get("method") == "tools/call":
                tool_name = request["params"]["name"]
                if tool_name == "search_web":
                    query = request["params"]["arguments"]["query"]
                    
                    # Set timeout for search operation
                    signal.alarm(45)  # 45 second timeout for search
                    
                    try:
                        results = search_web(query)
                        signal.alarm(0)  # Cancel timeout
                        
                        # Format the response in a more Claude-friendly way
                        if isinstance(results, dict) and 'error' not in results:
                            formatted_text = f"Fetched data successfully:\n\n{json.dumps(results, indent=2)}"
                        else:
                            formatted_text = json.dumps(results, indent=2)
                            
                        response = {
                            "jsonrpc": "2.0",
                            "id": request.get("id"),
                            "result": {
                                "content": [{
                                    "type": "text",
                                    "text": formatted_text
                                }]
                            }
                        }
                        print(json.dumps(response))
                        sys.stdout.flush()
                    except TimeoutError:
                        signal.alarm(0)
                        error_response = {
                            "jsonrpc": "2.0",
                            "id": request.get("id"),
                            "result": {
                                "content": [{
                                    "type": "text",
                                    "text": json.dumps({"error": "Search timed out after 45 seconds", "query": query})
                                }]
                            }
                        }
                        print(json.dumps(error_response))
                        sys.stdout.flush()
                    
        except Exception as e:
            error_response = {
                "jsonrpc": "2.0",
                "id": request.get("id") if 'request' in locals() else None,
                "error": {
                    "code": -32603,
                    "message": str(e)
                }
            }
            print(json.dumps(error_response), file=sys.stderr)
            sys.stderr.flush()

if __name__ == "__main__":
    main()

// Define an enhanced agent that can use tools
class AgentWithToolsInput {
  query string
  available_tools string[]
}

class AgentWithToolsOutput {
  response string
  tool_to_use string?
  tool_parameters string?
}

function AgentWithTools(input: AgentWithToolsInput) -> AgentWithToolsOutput {
  client CustomGPT4oMini
  prompt #"
    You are a helpful assistant that can use tools to accomplish tasks.
    
    Available tools:
    {% for tool in input.available_tools %}
    - {{ tool }}
    {% endfor %}
    
    User query: {{ input.query }}
    
    Respond to the user's query. If you need to use a tool to answer the query, specify which tool to use
    in the tool_to_use field and provide any necessary parameters in the tool_parameters field as a JSON string.
    
    For example, if the user asks about the weather in New York, you might respond:
    {
      "response": "I'll check the current weather in New York for you.",
      "tool_to_use": "get_weather",
      "tool_parameters": "{\\"location\\": \\"New York\\"}"
    }
    
    If the user asks about extracting information from a resume, you might respond:
    {
      "response": "I can help extract information from your resume. Please provide the resume text.",
      "tool_to_use": "extract_resume",
      "tool_parameters": null
    }
    
    If you don't need to use a tool, leave the tool_to_use and tool_parameters fields empty.
    
    {{ ctx.output_format }}
  "#
}

// Test the agent with a weather query
test agent_weather_query {
  functions [AgentWithTools]
  args {
    input {
      query "What's the weather like in San Francisco?"
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
}

// Test the agent with a resume query
test agent_resume_query {
  functions [AgentWithTools]
  args {
    input {
      query "Can you help me extract information from my resume?"
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
}

// Test the agent with a general query
test agent_general_query {
  functions [AgentWithTools]
  args {
    input {
      query "What is BAML?"
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
}

// Test the agent with a DuckDuckGo search query
test agent_duckduckgo_search_query {
  functions [AgentWithTools]
  args {
    input {
      query "What are the latest developments in AI?"
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
} 
// Define an agent planner that generates a sequence of tool calls based on a paragraph
class AgentPlannerInput {
  paragraph string
  available_tools string[]
}

class AgentPlannerOutput {
  plan_description string
  tool_calls ToolCall[]
}

class ToolCall {
  tool_name string
  parameters string  // JSON string of parameters
  purpose string     // Brief explanation of why this tool is being called
}

function AgentPlanner(input: AgentPlannerInput) -> AgentPlannerOutput {
  client CustomGPT4oMini
  prompt #"
    You are an AI planning assistant that creates a sequence of tool calls to accomplish tasks described in a paragraph.
    
    Available tools:
    {% for tool in input.available_tools %}
    - {{ tool }}
    {% endfor %}
    
    Input paragraph: {{ input.paragraph }}
    
    Your task is to analyze the paragraph and create a plan with a sequence of tool calls that would be needed to accomplish the tasks described.
    
    For each tool call, specify:
    1. The tool name (must be one of the available tools)
    2. The parameters as a JSON string
    3. A brief explanation of why this tool is being called
    
    For example, if the paragraph is "I need to check the weather in New York and then search for information about climate change", your response might be:
    {
      "plan_description": "First check the weather in New York, then search for information about climate change.",
      "tool_calls": [
        {
          "tool_name": "get_weather",
          "parameters": "{\\"location\\": \\"New York\\"}",
          "purpose": "To check the current weather in New York"
        },
        {
          "tool_name": "search",
          "parameters": "{\\"query\\": \\"information about climate change\\"}",
          "purpose": "To find information about climate change"
        }
      ]
    }
    
    If no tool calls are needed or the available tools don't match the needs in the paragraph, return an empty array for tool_calls.
    
    {{ ctx.output_format }}
  "#
}

// Test the planner with a paragraph requiring multiple tools
test planner_multiple_tools {
  functions [AgentPlanner]
  args {
    input {
      paragraph "I need to check the weather in San Francisco and then extract information from my resume."
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
}

// Test the planner with a paragraph requiring a single tool
test planner_single_tool {
  functions [AgentPlanner]
  args {
    input {
      paragraph "I need to search for information about machine learning algorithms."
      available_tools ["get_weather", "search", "extract_resume", "duckduckgo_search"]
    }
  }
}

// Test the planner with a paragraph that doesn't require tools
test planner_no_tools {
  functions [AgentPlanner]
  args {
    input {
      paragraph "Tell me about your capabilities as an AI assistant."
      available_tools ["sum", "subtract", "multiply", "divide"]
    }
  }
}
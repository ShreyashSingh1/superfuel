// Define an agent that can process user queries
class AgentInput {
  query string
}

class AgentOutput {
  response string
  action string?
}

function Agent(input: AgentInput) -> AgentOutput {
  client CustomGPT4oMini
  prompt #"
    
    {{ _.role("system") }}     
    You are a helpful assistant that can answer questions about resumes.

    {{ _.role("user")}} 
    
    User query: {{ input.query }}
    
    Respond to the user's query. If the query is about extracting information from a resume,
    suggest using the ExtractResume function and set the action field to "extract_resume".
    
    For example, if the user asks "Can you help me extract data from my resume?", your response
    should be helpful and you should set action to "extract_resume".
    
    If the query is not about resume extraction, provide a helpful response and leave the action field empty.
    
    {{ ctx.output_format }}
  "#
}

// Test the agent with a sample query
test agent_test {
  functions [Agent]
  args {
    input {
      query "Can you help me extract information from a resume?"
    }
  }
}

// Test the agent with a non-resume query
test agent_general_query {
  functions [Agent]
  args {
    input {
      query "What is BAML?"
    }
  }
} 
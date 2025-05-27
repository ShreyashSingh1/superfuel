from baml_client.sync_client import b
from baml_client.types import Resume

def example(raw_resume: str) -> Resume: 
  # BAML's internal parser guarantees ExtractResume
  # to be always return a Resume type
  response = b.ExtractResume(raw_resume)
  return response

def example_stream(raw_resume: str) -> Resume:
  stream = b.stream.ExtractResume(raw_resume)
  for msg in stream:
    print(msg) # This will be a PartialResume type
  
  # This will be a Resume type
  final = stream.get_final_response()

  return final

def process_query_with_tools(query):
    """Process a user query using the BAML agent with tools"""
    response = b.AgentWithTools(input={"query": query, "available_tools": ["get_weather", "search", "extract_resume", "duckduckgo_search"]})
    return response

def process_query(query):
    """Process a user query using the BAML agent"""
    response = b.Agent(input={"query": query})
    return response

def generate_plan(paragraph, tools):
    """Generate a plan with tool calls based on a paragraph and list of tools
    
    Args:
        paragraph (str): The input paragraph text to analyze
        tools (list): List of available tools
        
    Returns:
        dict: A plan with sequence of tool calls
    """
    response = b.AgentPlanner(input={"paragraph": paragraph, "available_tools": tools})
    return response
  
if __name__ == "__main__":
  with open("artifacts/resume.txt", "r") as f:
    raw_resume = f.read()
    print(example(raw_resume))
    print(example_stream(raw_resume))
    
    query = "tell new ai inventions"
    agent_response = process_query(query)
    print(f"Agent response: {agent_response}")
    
    agent_response_with_tools = process_query_with_tools(query)
    print(f"Agent response with tools: {agent_response_with_tools}")
    
    # Example of using the planner
    paragraph = "I need to check the weather in New York and search for information about machine learning"
    tools_list = ["get_weather", "search", "extract_resume"]
    plan = generate_plan(paragraph, tools_list)
    print(f"Generated plan: {plan}")
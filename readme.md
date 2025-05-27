# Math Operations Planner

A powerful tool that generates and executes plans for mathematical operations based on natural language descriptions.

## Overview

This system takes a natural language description of mathematical operations and:
1. Generates a structured plan with a sequence of tool calls
2. Executes those tool calls in order
3. Handles dependencies between operations
4. Returns the final results

## Features

- **Natural Language Processing**: Understands math operations described in plain English
- **Automatic Planning**: Generates a sequence of tool calls to solve the problem
- **Dependency Handling**: Manages results between operations
- **Error Recovery**: Robust error handling and parameter parsing
- **Flexible Reference Patterns**: Handles various ways to reference previous results

## Supported Operations

- **sum**: Add two numbers
- **subtract**: Subtract one number from another
- **multiply**: Multiply two numbers
- **divide**: Divide one number by another

## Usage Examples

### Basic Operation

```python
paragraph = "multiply 10 by 20"
tools_list = ["sum", "subtract", "multiply", "divide"]
plan = generate_plan(paragraph, tools_list)
results = execute_plan(plan)
```

### Chained Operations

```python
paragraph = "add 20 and 30, then divide it by the sum of 2 and 3"
plan = generate_plan(paragraph, tools_list)
results = execute_plan(plan)
```

### Sequential Operations

```python
paragraph = "multiply 5 by 4, then subtract 3 from the result"
plan = generate_plan(paragraph, tools_list)
results = execute_plan(plan)
```

## How It Works

The system uses a two-step process:

1. **Plan Generation**: The BAML agent analyzes the natural language description and creates a structured plan with tool calls.
2. **Plan Execution**: The executor processes each tool call in sequence, handling dependencies between operations.

### Under the Hood

The system includes:
- Post-processing to handle incomplete plans
- JSON parameter parsing with error recovery
- Variable reference resolution
- Intermediate result tracking

## Example Output

For the input "multiply 5 by 4, then subtract 3 from the result":

```
Generated plan: plan_description='First multiply 5 by 4, then subtract 3 from the result.' 
tool_calls=[
    ToolCall(tool_name='multiply', parameters='{"a": 5, "b": 4}', purpose='To calculate the product of 5 and 4.'), 
    namespace(tool_name='subtract', parameters='{"a": "result_of_first_sum", "b": 3}', purpose='To subtract 3 from the result of multiplication')
]

Execution results: [
    {'tool': 'multiply', 'parameters': {'a': 5, 'b': 4}, 'result': 20, 'status': 'success'}, 
    {'tool': 'subtract', 'parameters': {'a': 20, 'b': 3}, 'result': 17, 'status': 'success'}
]
```

## Dependencies

- BAML client for plan generation
- JSON for parameter parsing

## Future Improvements

- Support for more complex math operations
- Enhanced error handling and recovery
- User interface for interactive planning
- Support for variables and equations
- Integration with other systems

## License

MIT License

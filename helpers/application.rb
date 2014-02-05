
def colour_class(solution_to_check, puzzle_value, current_solution_value, solution_value)
  
  must_be_guessed = puzzle_value == "0"
  tried_to_guess = current_solution_value.to_i != 0
  guessed_incorrectly = current_solution_value != solution_value

  if guessed_incorrectly
    puts "puzzle_value = " + puzzle_value.to_s
    puts "current_solution_value = " + current_solution_value.to_s
    puts "solution_value = " + solution_value.to_s
    puts "solution_to_check = " + solution_to_check.to_s

    puts "must_be_guessed = " + must_be_guessed.to_s
    puts "tried_to_guess = " + tried_to_guess.to_s
    puts "guessed_incorrectly = " + guessed_incorrectly.to_s
    puts " "
  end

  if solution_to_check && 
    must_be_guessed && 
    tried_to_guess && 
    guessed_incorrectly
      'incorrect'
  elsif !must_be_guessed
      'value-provided'
    else 
      'white'
  end
end

def cell_value(value)
  value.to_i == 0 ? "" : value
end

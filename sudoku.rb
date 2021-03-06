require 'sinatra'
require_relative './lib/sudoku'
require_relative './lib/cell'
require_relative './helpers/application'
require 'sinatra/partial' 
require 'rack-flash'
enable :sessions
set :session_secret, "17051982"
set :partial_template_engine, :erb
use Rack::Flash
configure :production do
  require 'newrelic_rpm'
end

get '/' do
	session[:current_solution] = nil if params[:level]
	prepare_to_check_solution
	generate_new_puzzle_if_necessary
	@current_solution = session[:current_solution] || session[:puzzle]
	@solution = session[:solution]
	@puzzle = session[:puzzle]
	session[:check_solution] = nil
	erb :index
end

post '/' do
	cells = params[:cell]
	session[:current_solution] = box_order_to_row_order(cells).map { |value| value.to_i }.join
	session[:check_solution] = true
	redirect to("/")
end

get '/solution' do
	flash[:notice] = nil
	@solution = session[:solution]
	@puzzle = session[:puzzle]
	@current_solution = session[:solution]
	erb :index
end

def random_sudoku
	seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
	sudoku = Sudoku.new(seed.join)
	sudoku.solve!
	sudoku.to_s.chars
end

def puzzle(sudoku)
	level = params[:level] == "Hard" ? 40 : 25
	index_to_remove = (0..80).to_a.sample(level)
	session[:solution].map.with_index { |n, i| n = index_to_remove.include?(i) ? "0" : n }
end

def prepare_to_check_solution
	@check_solution = session[:check_solution]
   flash[:notice] = @check_solution ? "Green values are WRONG!" : nil
end

def generate_new_puzzle_if_necessary
	return if session[:current_solution]
	sudoku = random_sudoku
	session[:solution] = sudoku
	session[:puzzle] = puzzle(sudoku)
	session[:current_solution] = session[:puzzle]
end

def box_order_to_row_order(cells)
	boxes = cells.each_slice(9).to_a
	(0..8).to_a.inject([]) {|memo, i|
		first_box_index = i / 3 * 3
		three_boxes = boxes[first_box_index, 3]
		three_rows_of_three = three_boxes.map do |box|
			row_number_in_a_box = i % 3
			fistr_cell_in_the_row_index = row_number_in_a_box * 3
			box[fistr_cell_in_the_row_index, 3]
		end
		memo += three_rows_of_three.flatten
	}
end

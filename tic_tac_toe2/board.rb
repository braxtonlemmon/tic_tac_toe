#!/home/braxton/.rbenv/shims/ruby

class Board
	attr_accessor :board
	
	def initialize
		@board = Array.new(3) { Array.new(3) { Cell.new } }
	end
	
	def reset
		@board = Array.new(3) { Array.new(3) { Cell.new } }
	end

	def value(y, x)
		board[y][x]
	end

	def change_value(y, x, piece)
		value(y, x).content = piece
	end

	def show
		board.map do |row|
			line = []
			(0..2).each { |i| line << row[i].content }
			puts '[' + line.join('][') + ']'
		end
	end

	def show_num
		nums = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
		nums.each { |row| puts '[' + row.join('][') + ']' }
	end

	# TODO: optimize
	def win?
		test = board.flatten.map { |cell| cell.content }
		case true
		when test[0] != ' ' && test[0] == test[1] && test[1] == test[2] then true
		when test[3] != ' ' && test[3] == test[4] && test[4] == test[5] then true
		when test[6] != ' ' && test[6] == test[7] && test[7] == test[8] then true
		when test[0] != ' ' && test[0] == test[3] && test[3] == test[6] then true
		when test[1] != ' ' && test[1] == test[4] && test[4] == test[7] then true
		when test[2] != ' ' && test[2] == test[5] && test[5] == test[8] then true
		when test[0] != ' ' && test[0] == test[4] && test[4] == test[8] then true
		when test[6] != ' ' && test[6] == test[4] && test[4] == test[2] then true
		else false
		end
	end

	def tie?
		board.flatten.map { |cell| cell.content }.none? { |i| i == ' ' }
	end

end
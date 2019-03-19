#!/home/braxton/.rbenv/shims/ruby
module BoardTools
	def update_board(col, row)
		column = {a: 0, b: 1, c: 2}
		col = column[col.to_sym]
	  self.board[row][col] ||= true
	end

	def check_for_win(board)
			case true
			when board[0].all? { |x| x } then true
			when board[1].all? { |x| x } then true
			when board[2].all? { |x| x } then true
			when board[0][0] && board[1][0] && board[2][0] then true
			when board[0][1] && board[1][1] && board[2][1] then true
			when board[0][2] && board[1][2] && board[2][2] then true
			when board[0][0] && board[1][1] && board[2][2] then true
			when board[0][2] && board [1][1] && board [2][0] then true
			else false
			end
	end

	def clear_board(board)
		board.each do |row|
			row.map! { |x| x = false }
		end
	end
end




class Player
	include BoardTools

	attr_reader :name, :mark
	attr_accessor :board, :score

	def initialize(name, mark)
		@name = name
		@score = 0
		@board = [[false, false, false],
							[false, false, false],
							[false, false, false]]
		@mark = mark
	end
	
	def to_s
		score == 0 || score > 1 ? "#{name} has #{score} points." : "#{name} has #{score} point."
	end

	def win_point
		self.score += 1
	end
end

class MasterBoard
	include BoardTools

	attr_accessor :board, :game_board
	
	def initialize
		@board = [[false, false, false],
							[false, false, false],
							[false, false, false]]
		@game_board = [["  ", " a", "  b", "  c"],
									 ["0 ", "[ ]", "[ ]", "[ ]"],
									 ["1 ", "[ ]", "[ ]", "[ ]"],
									 ["2 ", "[ ]", "[ ]", "[ ]"]]					
	end

	def update_display(col, row, mark)
		column = {a: 0, b: 1, c: 2}
		col = column[col.to_sym]
	  self.game_board[row+1][col+1] = "[#{mark}]"
	end

	def clear_display
    @game_board = [["  ", " a", "  b", "  c"],
									 ["0 ", "[ ]", "[ ]", "[ ]"],
									 ["1 ", "[ ]", "[ ]", "[ ]"],
									 ["2 ", "[ ]", "[ ]", "[ ]"]]	
	end

	def check_for_tie
		@board.all? do |row|
			row.all? { |x| x }
		end
	end
end

def play_game(player1, player2, master_board)
	current_player = player1
	while true
		puts "************************************"
		puts "\n#{current_player.name}'s turn!\n\n"
		puts master_board.game_board.map { |row| row.join('') }
		puts
		col = ''
		row = ''
		
		until col.match(/[abc]/) && col.length == 1
			puts "#{current_player.name}, pick a column [a b c]: "
			col = gets.chomp.downcase
		end
		
		until row.match(/[012]/) && row.length == 1
			puts "#{current_player.name}, pick a row [0 1 2]: "
			row = gets.chomp
		end
		
		puts "#{current_player.name}, you picked #{col}#{row}"
		current_player.update_board(col, row.to_i)
		master_board.update_board(col, row.to_i)
		master_board.update_display(col, row.to_i, current_player.mark)
		current_player.check_for_win(current_player.board) ? break : false
		if master_board.check_for_tie
			tie = true
			break
		end
		current_player == player1 ? (current_player = player2) : (current_player = player1)
	end
	puts master_board.game_board.map { |row| row.join('') }
	
	if tie
		puts "\n\nIt's a tie..."
	else
		puts "\n\n#{current_player.name} wins!"
		current_player.win_point
	end
end

# Setup game
puts "Welcome!"
puts "Are you ready for a riveting game of Tic-Tac-Toe?\n\n"
puts "Please enter a name for player one (x): "
player1 = Player.new(gets.chomp, 'x')
puts "\nPlease enter a name for player two (o): "
player2 = Player.new(gets.chomp, 'o')
puts "\nGood luck #{player1.name} and #{player2.name}!\n\n"
master_board = MasterBoard.new

stop = false
until stop
	play_game(player1, player2, master_board)
	puts player1
	puts player2
	puts "\n\nWould you like to play another round? (y/n)"
	response = gets.chomp.downcase
	if response[0] == 'y'
		player1.clear_board(player1.board)
		player2.clear_board(player2.board)
		master_board.clear_board(master_board.board)
		master_board.clear_display
	else
		stop = true
	end
end


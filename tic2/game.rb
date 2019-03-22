#!/home/braxton/.rbenv/shims/ruby

require_relative 'board'
require_relative 'cell'
require_relative 'player'

class Game 
  attr_accessor :player1, :player2, :gameboard, :current_player

	def initialize(players, gameboard = Board.new)
		@player1, @player2 = players.shuffle
		@current_player = player1
		@gameboard = gameboard
	end

	def introduce
		puts "#{player1.name} (#{player1.piece}) has randomly been selected to begin."
		puts "#{player2.name} (#{player2.piece}) will go second."
		puts 'Use the number keys 1-9 to select a space on the board.'
		puts "Good luck!\n\n"
	end

	def play
		introduce
		keep_playing = true
		while keep_playing
			take_turn
			if gameboard.win? || gameboard.tie?
				gameboard.show
				puts gameboard.win? ? "\n#{current_player.name} wins! Play again?" : "\nIt's a tie! Play again?"
				if gets.chomp.downcase[0] == 'y'
					gameboard.reset
					swap_players
					play
				else 
					keep_playing = false
				end
			else
				swap_players
			end
		end
	end
	
	def ask_ending
		gameboard.win? ? "#{current_player.name} wins!" : "It's a tie!"
	end

	def take_turn
		y, x = choice_conversion(choose_spot)
		update_board(y, x)
	end

	def choose_spot
		response = 0
		until response.to_i.between?(1, 9)
			gameboard.show_num
			puts ''
			gameboard.show
			puts "\n#{current_player.name}, choose a spot to play (1-9): "
			response = gets.chomp
		end
		response
	end

	def update_board(y, x)
		if gameboard.board[y][x].content == ' '
			gameboard.change_value(y, x, current_player.piece)
		else
			take_turn
		end
	end

	def swap_players
		current_player == player1 ? (self.current_player = player2) : (self.current_player = player1)
	end
	
	def choice_conversion(player_choice)
		options = {
			'1' => [0, 0],
			'2' => [0, 1],
			'3' => [0, 2],
			'4' => [1, 0],
			'5' => [1, 1],
			'6' => [1, 2],
			'7' => [2, 0],
			'8' => [2, 1],
			'9' => [2, 2]
		}
		options[player_choice]
	end

end

def setup_game
	puts "Welcome to Tic-Tac-Toe!\n"
	puts "Please enter a name for player one (x): "
	person1 = Player.new(gets.chomp, 'x')
	puts "\nPlease enter a name for player two (o): "
	person2 = Player.new(gets.chomp, 'o')
	puts "\n\nAlright! Let's play!\n\n"
	players = [person1, person2]
	game = Game.new(players)
	game.play
end

setup_game






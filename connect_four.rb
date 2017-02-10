
class Board
  attr_accessor :board, :poz, :moved
  attr_reader :pl1, :pl2

  def initialize
    @board = []
    6.times { @board << make_row }
    @pl1 = Player.new
    @pl2 = Player.new
  end

  def make_row
    row = []
    7.times { row << '_' }
    row
  end

  def play
    system "clear"
    while true
      print_board
      move(@pl1)
      winner if checkAll? poz
      print_board
      move(@pl2)
      winner if checkAll? poz
    end
  end

  def print_board
    @board.each do |row|
      row.each { |poz| print "  " + poz};
      puts
    end
  end

  def winner
    puts "Congratulations #{@moved.instance_variable_get("@name")}, you have won!"
    print_board
    abort
  end

  def move pl
    print "#{pl.instance_variable_get("@name")}, please pick a column number to play (0-6)"
    num = gets.chomp.to_i
    unless num.between?(0,6)
      puts "Invalid column number!"
      move pl
      return
    end
    for i in -5..0
       if @board[i.abs][num] == '_'
         @board[i.abs][num] = pl.instance_variable_get("@color")
         @poz = [i.abs, num]         
         system 'clear'
         @moved = pl
         return
       end
    end
    puts "That column - #{num} - is already full please choose an other one!"
    move pl
  end

  def checkAll? poz
    x = poz[0]
    y = poz[1]
    base = @board[x][y]
    i=1
    return true if (checkWinHor? x, y, i, base) >= 4
    return true if (checkWinVer? x, y, i, base) >= 4
    return true if (checkWinDiag1? x, y, i, base) >= 4
    return true if (checkWinDiag2? x, y, i, base) >= 4
  end

  def checkWinHor? x,y,i,base
    count = 1
    while @board[x][y+i] == base
      count += 1
      i+=1
    end
    i = 1
    while @board[x][y-i] == base
      count +=1
      i+=1
    end
    count
  end

  def checkWinVer? x,y,i,base
    count = 1
    while (x+i).between?(0,5) && @board[x+i][y] == base
      count += 1
      i+=1
    end
    i = 1
    while (x-i).between?(0,5) && @board[x-i][y] == base
      count +=1
      i+=1
    end
    count
  end

  def checkWinDiag1? x,y,i,base
    count = 1
    while (x+i).between?(0,5) && @board[x+i][y+i] == base
      count += 1
      i+=1
    end
    i = 1
    while (x-i).between?(0,5) && @board[x-i][y-i] == base
      count +=1
      i+=1
    end
    count
  end

  def checkWinDiag2? x,y,i,base
    count = 1
    while (x+i).between?(0,5) && @board[x+i][y-i] == base
      count += 1
      i += 1
    end
    i = 1
    while (x-i).between?(0,5) && @board[x-i][y+i] == base
      count +=1
      i+=1
    end
    count
  end
end


class Player
  @@colors = ["\u{2670}", "\u{2665}","\u{2618}","\u{263B}"]
  attr_reader :name, :color

  def initialize
    @name = name
    @color = color
  end

  private
  def name
    puts "Please enter your name: "
    gets.chomp
  end

  def color
    puts "Please choose your color!"
    @@colors.each_with_index do |color, index|
      puts "#{index}: #{color}"
    end
    choice = gets.chomp.to_i
    if @@colors[choice] == nil
      puts "Invalid choice, auto assigning color!"
      @@colors.shift
    else
      @@colors.delete_at(choice)
    end
  end
end

b = Board.new
b.play

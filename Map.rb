require "./Field.rb"

class Map
    def initialize
        @fields = Array.new
        @size = 0
        @difficulty = 0
        @number_of_mines = 0
    end
    def fill p_size, p_difficulty
        @size = p_size
        @difficulty = p_difficulty
        @number_of_mines = (@size * @size * @difficulty).to_i
        @size.times {@fields << Array.new}
        @fields.each {|row| @size.times {row << Field.new}}
        row = 0
        column = 0
        @number_of_mines.times do
            loop do
                field = @fields[row = rand(@size)][column = rand(@size)]
                break if !field.get_status[0]
            end
            @fields[row][column].set_mine true
            get_surrounding_fields(row, column).each {|field| field.increase_number_of_mines_nearby}
        end
    end
    def get_surrounding_fields p_row, p_column
        surrounding_fields = Array.new
        row = p_row
        column = p_column
        unless p_row <= 0
            row -= 1
        end
        unless p_column <= 0
            column -= 1
        end
        loop do
            loop do
                unless row == p_row and column == p_column
                    surrounding_fields << @fields[row][column]
                end
                break if column == p_column + 1 or column == @size - 1
                column += 1
            end
            column = p_column
            unless p_column <= 0
                column -= 1
            end
            break if row == p_row + 1 or row == @size - 1
            row += 1
        end
        surrounding_fields
    end
    def reset
        initialize
    end
    def discover p_row, p_column
        field = @fields[p_row][p_column]
        if field.get_status[0]
            return false
        else
            unless field.get_status[1] or field.get_status[2]
                if field.get_number_of_mines_nearby == nil or field.get_number_of_mines_nearby == 0
                    unless p_row == 0
                        discover p_row - 1, p_column
                    end
                    unless p_column == 0
                        discover p_row, p_column - 1
                    end
                    unless p_row == @size
                        discover p_row + 1, p_column
                    end
                    unless p_column == @size
                        discover p_row, p_column + 1
                    end
                else
                    field.set_discovered true
                end
                return true
            end
        end
    end
    def place_flag p_row, p_column
        @fields[p_row][p_column].set_flag true
    end
    def decrease_number_of_mines
        @number_of_mines -= 1
    end
    def set p_fields
        if p_fields
            @fields = p_fields
        end
    end
    def get
        @fields
    end
    def get_size
        return @size
    end
    def get_difficulty
        return @difficulty
    end
    def get_number_of_mines
        return @number_of_mines
    end
end

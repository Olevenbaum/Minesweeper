require "os"
require "colorize"
require "./Map.rb"
require "./Field.rb"

class Main
    def initialize
        @map = Map.new
        @clear_terminal = get_os
    end
    def main
        system "#{@clear_terminal}"
        puts "Welcome to Minesweeper!"
        puts
        start_game
        show_map
    end
    def start_game
        puts "Please insert the size of the map: "
        puts "(map is square, size is the length of the sides)"
        size = gets.chomp.to_i
        puts "Please insert the difficulty:"
        puts "(difficulty is a number between 0 and 1 (e.g. 0.3 -> 30% of the map are mines))"
        difficulty = gets.chomp.to_f
        @map.fill size, difficulty
    end
    def show_menu
        puts "1: Start new game"
        puts "2: Exit game"
        loop do
            puts "Please insert the number of the wanted option:"
            case gets.chomp
            when 1
                start_game
                break
            when 2
                exit
                break
            else
                puts "Please use any number of the list above:"
            end
        end
        
        puts
    end
    def select_field
        row = ""
        column = ""
        puts "Insert number of row you want to select:"
        puts "(Type 'exit' to get back to the menu)"
        loop do
            row = gets.chomp
            if row == exit
                
            end
            row = row.to_i
            break if row > 0 and row < @map.get_size
        end
        puts "Insert number of column you want to select:"
        puts "(Type 'exit' to get back to the menu)"
        column = gets.chomp
        loop do
            column = gets.chomp
            if column == exit
                
            end
            column = column.to_i
            break if column > 0 and column < @map.get_size
        end
        [row.to_i, column.to_i]
    end
    def show_map
        output = ""
        @map.get.each {|row|
            row.each {|field|
                if field.get_status[1]
                    if field.get_status[0]
                        output << "| ☼ "
                    elsif field.get_status[2]
                        output << "| F "
                    elsif field.get_number_of_mines_nearby != nil && field.get_number_of_mines_nearby != 0
                        output << "| #{field.get_number_of_mines_nearby} "
                    else
                        output << "|   "
                    end
                else
                    output += "| █ "
                end
            }
            puts output.delete_prefix "|"
            divider = ""
            @map.get_size.times {divider << "----"}
            puts divider.delete_prefix "-"
            output = ""
        }
    end
    def reset_map
        @map.reset
    end
    def get_os
        clear_command = ""
        if OS.windows?
            clear_command = "cls"
        else
            clear_command = "clear"
        end
        clear_command
    end
end

Main.new.main

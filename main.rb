BEGIN {
    puts "OS installed?"
    if !system "gem list -i os"
        puts "installing OS..."
        system "gem i os"
    end
    puts "colorized installed?"
    if !system "gem list -i colorize"
        puts "installing colorized..."
        system "gem i colorize"
    end
    puts
    puts "Game ready..."
    sleep 1
    puts
}

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
        show_menu
    end
    def start_game
        puts "Please insert the size of the map: "
        puts "(map is square, size is the length of the sides)"
        size = gets.chomp.to_i
        puts "Please insert the difficulty:"
        puts "(difficulty is a number between 0 and 1 (e.g. 0.3 -> 30% of the map are mines))"
        difficulty = gets.chomp.to_f
        @map.fill size, difficulty
        system "#{@clear_terminal}"
        show_map
    end
    def show_menu
        puts "1: Start new game"
        puts "2: Exit game"
        puts
        loop do
            puts "Please insert the number of the wanted option:"
            case gets.chomp.to_i
            when 0
                puts
                puts "Please use any number of the list above:"
            when 1
                start_game
                break
            when 2
                exit
                break
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
        [row.to_i - 1, column.to_i - 1]
    end
    def show_map
        puts
        counter = 0
        output = "    " + "|".white
        divider = "-----"
        Array(0..(@map.get_size - 1)).each {|number| output << "|".white + " #{(number + 1).to_s.ljust 2}".black}
        @map.get_size.times {divider << "----"}
        puts output
        @map.get.each {|row|
            counter += 1
            output = " #{counter.to_s.ljust 2}".black + "|".white
            if counter == 1
                big_divider = "====="
                @map.get_size.times {big_divider << "===="}
                puts big_divider.white
            else
                puts divider.white
            end
            row.each {|field|
                if field.get_status[1]
                    if field.get_status[0]
                        output << "|".white + " ☼ ".red
                    elsif field.get_status[2]
                        output << "|".white + " F "
                    elsif field.get_number_of_mines_nearby != nil and field.get_number_of_mines_nearby != 0
                        output << "| ".white + "#{field.get_number_of_mines_nearby} ".green
                    else
                        output << "|".white + "   "
                    end
                else
                    output += "|".white + " █ ".black
                end
            }
            puts output
        }
        puts
    end
    def get_user_input p_type, p_expectations
        input = ""
        revision = false
        loop do
            if input == "exit"
                
            end
            p_expectations.to_a.each {|expectation|
                if input == expectation
                    revision = true
                end
            }
            break if revision
        end
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

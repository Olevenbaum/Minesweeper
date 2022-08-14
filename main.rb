BEGIN {
    puts "checking gems"
    if !system "gem list -i os"
        puts "installing OS..."
        system "gem i os"
    end
    if !system "gem list -i colorize"
        puts "installing colorized..."
        system "gem i colorize"
    end
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
        show_menu
    end
    def start_game
        puts "Please insert the size of the map:"
        puts "(map is square, size is the length of the sides)"
        size = get_user_input "i", Array(1..100)
        puts "Please insert the difficulty:"
        puts "(difficulty is a number between 0 and 1 (e.g. 0.3 -> 30% of the map are mines))"
        counter = 0
        possibilities = [counter]
        20.times {possibilities << (counter += 0.05).round(2)}
        difficulty = get_user_input "f", possibilities
        @map.fill size, difficulty
        system "#{@clear_terminal}"
        show_map
        puts

    end
    def show_menu
        puts "Welcome to Minesweeper!"
        puts
        puts "1: Start new game"
        puts "2: Exit game"
        puts
        puts "Please insert the number of the wanted option:"
        case get_user_input "i", [1, 2]
        when 1
            start_game
        when 2
            exit
        end  
        puts
    end
    def select_field
        puts "Insert number of row you want to select:"
        row = get_user_input "i", Array(1..@map.get_size)
        puts "Insert number of column you want to select:"
        column = get_user_input "i", Array(1..@map.get_size)
        [row.to_i - 1, column.to_i - 1]
        puts
    end
    def show_map
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
        value = Array.new
        loop do
            input = gets.chomp
            if input == "exit"
                return nil
            end
            if p_type == "string" or p_type == "str" or p_type == "s"
                value << input.to_s
            elsif p_type == "integer" or p_type == "int" or p_type == "i"
                value << input.to_i
            elsif p_type == "float" or p_type == "flo" or p_type == "f"
                value << input.to_f
            end
            p_expectations.to_a.each {|expectation|
                if value[0] == expectation
                    revision = true
                    break
                end
            }
            break if revision
            puts "Please type in a valid input."
        end
        value[0]
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

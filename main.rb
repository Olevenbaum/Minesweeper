require "os"
require "colorize"
require "./Map.rb"
require "./Field.rb"

BEGIN {
    install = "gem i"
    puts "checking gems..."
    puts
    print "os:".ljust 12
    begin
        unless system "gem list -i os"
            puts "installing OS..."
            system "#{install} os"
        end
    rescue => exception
        install =  "sudo #{install}"
        unless system "gem list -i os"
            puts "installing OS..."
            system "#{install} os"
        end
    end
    print "colorized:".ljust 12
    unless system "gem list -i colorize"
        puts "installing colorized..."
        system "#{install} colorize"
    end
    puts
}

class Main
    def initialize
        @map = Map.new
        @clear_terminal = get_os
    end
    def main
        system "#{@clear_terminal}"
        show_menu
    end
    def show_menu
        possible_input = Array(1..2)
        loop do
            puts "Welcome to Minesweeper!"
            puts
            puts "#{possible_input[0]}: Start new game"
            puts "#{possible_input[-1]}: Exit game"
            puts
            puts "Please insert the number of the wanted option:"
            case get_user_input "i", possible_input
            when possible_input[0]
                start_game
            when possible_input[-1]
                break
            when nil
                break
            end
            puts
        end
        puts "Thank you for playing Minesweeper!"
        puts
    end
    def start_game
        puts "Please insert the size of the map:"
        puts "(map is square, size is the length of the sides)"
        size = get_user_input "i", Array(1..100)
        unless size == nil
            puts "Please insert the difficulty:"
            puts "(difficulty is a number between 0 and 1 and a multiple of 0.05 (e.g. 0.3 -> 30% of the map are mines))"
            counter = 0
            possible_input = [counter]
            20.times {possible_input << (counter += 0.05).round(2)}
            difficulty = get_user_input "f", possible_input
            unless difficulty == nil
                loop do
                    @map.reset
                    @map.fill size, difficulty
                    loop do
                        show_map
                        break if select_field
                    end
                    possible_input = Array(1..2)
                    puts "#{possible_input[0]}: Start new game with equal settings"
                    puts "#{possible_input[-1]}: Exit to menu"
                    puts
                    puts "Please insert the number of the wanted option:"
                    case get_user_input "i", possible_input
                    when possible_input[0]
                    when possible_input[-1]
                        break
                    when nil
                        break
                    end
                    puts
                end
            end
        end
    end
    def select_field
        lost = false
        possible_input = Array(1..3)
        puts "Insert number of row you want to select:"
        row = get_user_input "i", Array(1..@map.get_size)
        unless row == nil
            puts "Insert number of column you want to select:"
            column = get_user_input "i", Array(1..@map.get_size)
            unless column == nil
                puts "Please type the number of the option you want to do with that field:"
                puts
                puts "#{possible_input[0]}: Uncover this field"
                puts "#{possible_input[1]}: Set a flag on that field"
                puts "#{possible_input[-1]}: Return to selecting process"
                case get_user_input "i", possible_input
                when possible_input[0]
                    unless @map.discover row - 1, column - 1
                        lost = true
                        lost_text
                    end
                when possible_input[1]
                    @map.place_flag row - 1, column - 1
                when possible_input[-1]
                    #TODO
                when nil
                    return true
                end
            end
        end
        lost
    end
    def show_map
        system "#{@clear_terminal}"
        puts
        counter = 0
        output = "   " + "|".white
        divider = "-----"
        Array(0..(@map.get_size - 1)).each {|number| output << "|".white + " #{(number + 1).to_s.ljust 2}".black}
        @map.get_size.times {divider << "----"}
        divider = divider.delete_suffix "-"
        puts output
        @map.get.each {|row|
            counter += 1
            output = " #{counter.to_s.ljust 2}".black + "|".white
            if counter == 1
                big_divider = "====="
                @map.get_size.times {big_divider << "===="}
                puts big_divider.delete_suffix("=").white
            else
                puts divider.white
            end
            row.each {|field|
                if field.get_status[2]
                    output << "|".white + " F ".yellow
                elsif field.get_status[1]
                    if field.get_number_of_mines_nearby != nil and field.get_number_of_mines_nearby != 0
                        output << "| ".white + "#{field.get_number_of_mines_nearby} ".green
                    elsif field.get_status[0]
                        output << "|".white + " ☼ ".red
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
    def lost_text
        system "#{@clear_terminal}"
        puts
        puts "$$$$$$$\\   $$$$$$\\   $$$$$$\\  $$\\      $$\\ $$\\ "
        puts "$$  __$$\\ $$  __$$\\ $$  __$$\\ $$$\\    $$$ |$$ |"
        puts "$$ |  $$ |$$ /  $$ |$$ /  $$ |$$$$\\  $$$$ |$$ |"
        puts "$$$$$$$\\ |$$ |  $$ |$$ |  $$ |$$\\$$\\$$ $$ |$$ |"
        puts "$$  __$$\\ $$ |  $$ |$$ |  $$ |$$ \\$$$  $$ |\\__|"
        puts "$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |\\$  /$$ |    "
        puts "$$$$$$$  | $$$$$$  | $$$$$$  |$$ | \\_/ $$ |$$\\ "
        puts "\\_______/  \\______/  \\______/ \\__|     \\__|\\__|"
        puts
        sleep 3
        puts "You just stepped on a mine! Try again..."
        gets
        system "#{@clear_terminal}"
    end
    def get_user_input p_type, p_expectations
        revision = false
        value = Array.new
        loop do
            input = gets.chomp
            if input == "exit" or nil
                system "#{@clear_terminal}"
                return nil
            end
            value << input
            p_expectations.to_a.each { |expectation|
                if value[-1] == expectation.to_s
                    revision = true
                    break
                end
            }
            if p_type == "string" or p_type == "str" or p_type == "s"
                value << input.to_s
            elsif p_type == "integer" or p_type == "int" or p_type == "i"
                value << input.to_i
            elsif p_type == "float" or p_type == "flo" or p_type == "f"
                value << input.to_f
            end
            break if revision
            puts "Please type in a valid input."
        end
        puts
        value[-1]
    end
    def reset_map
        @map.reset
    end
    def get_os
        if OS.windows?
            clear_command = "cls"
        else
            clear_command = "clear"
        end
        clear_command
    end
end

Main.new.main

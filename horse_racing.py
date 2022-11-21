from tkinter import *
import time
import random 

winner      = False
red_horse_x = 0
red_horse_y = 20

blue_horse_x = -23
blue_horse_y = 110

def start_race():
    global blue_horse_x
    global red_horse_x
    global winner 

    while winner == False:
        time.sleep(0.05)
        random_move_blue_horse = random.randint(0,20)
        random_move_red_horse = random.randint(0,20)
        # Update the x positions of both horses
        blue_horse_x += random_move_blue_horse
        red_horse_x += random_move_red_horse

        move_horses(random_move_red_horse,random_move_blue_horse)
        main_screen.update()
        winner = check_winner()

    if winner == "Tie!":
        Label(main_screen,text=winner,font=('calibri',20),bg="white",fg="green").place(x=275,y=435)
    elif winner == "Blue Horse":
        Label(main_screen,text=winner+" Wins!",font=('calibri',20),bg="white",fg="blue").place(x=200,y=435)
    else:
        Label(main_screen,text=winner+" Wins!",font=('calibri',20),bg="white",fg="red").place(x=200,y=435)

def move_horses(red_horse_random_move,blue_horse_random_move):
    canvas.move(red_horse,red_horse_random_move,0)
    canvas.move(blue_horse,blue_horse_random_move,0)

def check_winner():
    if blue_horse_x >= 550 and red_horse_x >=550:
        return "Tie!"
    if blue_horse_x >= 550:
        return "Blue Horse"
    if red_horse_x >= 550:
        return "Red Horse"
    return False


# Here I set up the main interface
main_screen = Tk()
main_screen.title('Horse Racing')
main_screen.geometry('600x500')
main_screen.config(background='white')

# Setting up the racetrack
canvas = Canvas(main_screen,width=600,height=200,bg="white")
canvas.pack(pady=20)

# Bring in the horses!
red_horse_img = PhotoImage(file="./images/red-horse.png")
blue_horse_img = PhotoImage(file="./images/blue-horse.png")

# Resizing the images
red_horse_img = red_horse_img.zoom(15)
red_horse_img = red_horse_img.subsample(50)
blue_horse_img = blue_horse_img.zoom(15)
blue_horse_img = blue_horse_img.subsample(90) # The blue horse image was bigger at first

# Add the horses to the racetrack
red_horse = canvas.create_image(red_horse_x,red_horse_y,anchor=NW,image=red_horse_img)
blue_horse = canvas.create_image(blue_horse_x,blue_horse_y,anchor=NW,image=blue_horse_img)

# Adding instructions to screen (text labels)
l1 = Label(main_screen,text='Decide which horse you like',font=('calibri',20),bg="white")
l1.place(x=140,y=250)
l2 = Label(main_screen,text='Click race when ready!',font=('calibri',20),bg='white')
l2.place(x=170,y=300)

b1 = Button(main_screen,text='RACE!',height=2,width=15,bg='white',font=('calibri',14),command=start_race)
b1.place(x=215,y=360)

main_screen.mainloop() # Keeps the interface from disappearing until exited
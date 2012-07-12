with Ada.Task_Identification;
with Ada.Text_IO;

procedure Sequential is

   use Ada.Task_Identification;
   use Ada.Text_IO;

   Child_Id : constant String := Image (Current_Task);

   type Reward is (Candy, No_Candy);

   type Dispenser is
      record
         Available_Candies : Natural := 20;
      end record;

   procedure Chew;
   --  Hiding away the fact that we just need to waste some time to get the
   --  point of this program across.

   function Pop
     (D : in out Dispenser)
   return Reward;
   --  Get one of those delicious candies!

   ------------
   --  Chew  --
   ------------

   procedure Chew
   is
   begin
      Put_Line (Child_Id & " is chewing on a candy.");
      delay 1.0; --  This is some fast chewing indeed!
   end Chew;

   -----------
   --  Pop  --
   -----------

   function Pop
     (D : in out Dispenser)
     return Reward
   is
   begin
      case D.Available_Candies is
         when 0 =>
            return No_Candy;
         when others =>
            D.Available_Candies := D.Available_Candies - 1;
            Put_Line (Child_Id &
                        " pops a candy from the dispenser.");
            Put_Line (Natural'Image (D.Available_Candies) &
                        " left in the dispenser");
            return Candy;
      end case;
   end Pop;

   Result        : Reward;
   Pez_Dispenser : Dispenser;

begin

   A_Child_Popping_Pez :
   loop
      Result := Pop (Pez_Dispenser);

      exit A_Child_Popping_Pez when Result = No_Candy;

      Chew;
   end loop A_Child_Popping_Pez;

   Put_Line ("No more candy! "
             & Child_Id
             & " runs out to play.");

end Sequential;

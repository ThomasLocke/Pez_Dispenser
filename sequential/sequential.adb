with Ada.Task_Identification;
with Ada.Text_IO;

procedure Sequential is

   use Ada.Task_Identification;
   use Ada.Text_IO;

   Task_Id : constant String := Image (Current_Task);

   type Reward is (Candy, No_Candy);

   type Dispenser is
      record
         Available_Candies : Natural := 20;
      end record;

   function Pop
     (D : in out Dispenser)
   return Reward;
   --  Get one of those delicious candies!

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
            Put_Line (Task_Id & " pops a candy from the dispenser.");
            Put_Line (Natural'Image (D.Available_Candies)
                      & " left in the dispenser");
            return Candy;
      end case;
   end Pop;

   Result        : Reward;
   Pez_Dispenser : Dispenser;

begin

   A_Child_Popping_Pez : loop
      Result := Pop (Pez_Dispenser);

      exit A_Child_Popping_Pez when Result = No_Candy;

      delay 1.0;
      --  This simulates chewing. Yes, a 1 second chew is pretty darn fast!
   end loop A_Child_Popping_Pez;

   Put_Line ("No more candy! " & Task_Id & " runs out to play.");

end Sequential;

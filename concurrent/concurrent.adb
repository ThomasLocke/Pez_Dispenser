with Ada.Task_Identification;
with Ada.Text_IO;

procedure Concurrent is

   use Ada.Task_Identification;
   use Ada.Text_IO;

   type Reward is (Candy, No_Candy);

   protected Pez_Dispenser is
      procedure Pop
        (Result  : out Reward;
         Task_Id : in  String);
      --  Get one of those delicious candies!
   private
      Available_Candies : Natural := 20;
   end Pez_Dispenser;

   ---------------------
   --  Pez_Dispenser  --
   ---------------------

   protected body Pez_Dispenser is
      -----------
      --  Pop  --
      -----------

      procedure Pop
        (Result  : out Reward;
         Task_Id : in  String)
      is
      begin
         case Available_Candies is
            when 0 =>
               Result := No_Candy;
            when others =>
               Result := Candy;

               Available_Candies := Available_Candies - 1;

               Put_Line (Task_Id & " pops a candy from the dispenser.");
               Put_Line (Natural'Image (Available_Candies)
                         & " left in the dispenser");
         end case;
      end Pop;
   end Pez_Dispenser;

   task type Child;
   --  A Child wants candy, and when the child gets a candy it spends time
   --  chewing it. If there's no more candy, the child exits the "pop" loop
   --  and goes out to play in the garden.

   --------------
   --  Child  --
   --------------

   task body Child
   is
      Task_Id : constant String := Image (Current_Task);
      Result  : Reward;
   begin
      A_Child_Popping_Pez : loop
         Pez_Dispenser.Pop (Result, Task_Id);

         exit A_Child_Popping_Pez when Result = No_Candy;

         delay 1.0;
      --  This simulates chewing. Yes, a 1 second chew is pretty darn fast!
      end loop A_Child_Popping_Pez;

      Put_Line ("No more candy! " & Task_Id & " runs out to play.");
   end Child;

   Alice  : Child;
   Bob    : Child;
   Clair  : Child;
   Dwayne : Child;

begin

   null;  --  We're not using the main environment task for anything.

end Concurrent;

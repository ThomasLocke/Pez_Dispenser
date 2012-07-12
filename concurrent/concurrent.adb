with Ada.Task_Identification;
with Ada.Text_IO;

procedure Concurrent is

   use Ada.Task_Identification;
   use Ada.Text_IO;

   type Reward is (Candy, No_Candy);

   protected Pez_Dispenser is
      procedure Pop
        (Result : out Reward);
      --  Get one of those delicious candies!
   private
      Available_Candies : Natural := 20;
   end Pez_Dispenser;

   procedure Chew;
   --  Hiding away the fact that we just need to waste some time to get the
   --  point of this program across.

   ------------
   --  Chew  --
   ------------

   procedure Chew
   is
      Child_Id : constant String := Image (Current_Task);
   begin
      Put_Line (Child_Id & " is chewing on a candy.");
      delay 1.0; --  This is some fast chewing indeed!
   end Chew;

   ---------------------
   --  Pez_Dispenser  --
   ---------------------

   protected body Pez_Dispenser is
   -----------
   --  Pop  --
   -----------

      procedure Pop
        (Result : out Reward)
      is
         Child_Id : constant String := Image (Current_Task);
      begin
         case Available_Candies is
            when 0 =>
               Result := No_Candy;
            when others =>
               Result := Candy;

               Available_Candies := Available_Candies - 1;

               Put_Line (Child_Id & " pops a candy from the dispenser.");
               Put_Line (Natural'Image (Available_Candies) &
                           " left in the dispenser");
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
      Child_Id : constant String := Image (Current_Task);
      Result   : Reward;
   begin
      A_Child_Popping_Pez :
      loop
         Pez_Dispenser.Pop (Result);

         exit A_Child_Popping_Pez when Result = No_Candy;

         Chew;
      end loop A_Child_Popping_Pez;

      Put_Line ("No more candy! "
                & Child_Id
                & " runs out to play.");
   end Child;

   Alice  : Child;
   Bob    : Child;
   Clair  : Child;
   Dwayne : Child;

begin

   null;  --  We're not using the main environment task for anything.

end Concurrent;

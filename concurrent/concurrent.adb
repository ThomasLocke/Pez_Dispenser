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

               Put ("One Candy given to " & Child_Id & ".");
               Put (Natural'Image (Available_Candies)
                    & " left in the dispenser.");
               New_Line;
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

   task body Child is
      Result : Reward;
   begin
      loop
         Pez_Dispenser.Pop (Result);

         if Result = Candy then
            for i in 1 .. 1_000_000_000 loop
               null;
               --  Yea, this is pointless. It's just here to make your CPU work
               --  a bit. Use your imagination and pretend that what's really
               --  going on here is chewing of delicious candy!
            end loop;
         end if;

         exit when Result = No_Candy;
      end loop;

      Put_Line ("No more candy! "
                & Image (Current_Task)
                & " runs out to play.");
   end Child;

   Alice  : Child;
   Bob    : Child;
   Clair  : Child;
   Dwayne : Child;

begin

   null;  --  We're not using the main environment task for anything.

end Concurrent;

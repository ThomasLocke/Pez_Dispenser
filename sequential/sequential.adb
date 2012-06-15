with Ada.Task_Identification;
with Ada.Text_IO;

procedure Sequential is

   use Ada.Task_Identification;
   use Ada.Text_IO;

   type Reward is (Candy, No_Candy);

   type Pez_Dispenser is
      record
         Available_Candies : Natural := 20;
      end record;

   procedure Pop
     (Dispenser : out Pez_Dispenser;
      Result    : out Reward);
   --  Get one of those delicious candies!

   -----------
   --  Pop  --
   -----------

   procedure Pop
     (Dispenser : out Pez_Dispenser;
      Result    : out Reward)
   is
   begin
      case Dispenser.Available_Candies is
         when 0 =>
            Result := No_Candy;
         when others =>
            Result := Candy;

            Dispenser.Available_Candies := Dispenser.Available_Candies - 1;

            Put ("One Candy given to " & Image (Current_Task) & ".");
            Put (Natural'Image (Dispenser.Available_Candies)
                 & " left in the dispenser.");
            New_Line;
      end case;
   end Pop;

   Result    : Reward;
   Dispenser : Pez_Dispenser;

begin

   loop
      Pop (Dispenser, Result);

      if Result = Candy then
         for i in 1 .. 1_000_000_000 loop
            null;
            --  Yea, this is pointless. It's just here to make your CPU work a
            --  bit. Use your imagination and pretend that what's really going
            --  on here is chewing of delicious candy!
         end loop;
      end if;

      exit when Result = No_Candy;
   end loop;

   Put_Line ("No more candy! I'll go out to play instead.");

end Sequential;

#Task 1
#Printing all alcoholic cocktails
SELECT name, volume AS ml, price
FROM drinks
WHERE type = 'коктейли' AND isAlcoholic = 'yes';    

#Task 2
/*Printing all foods and drinks for a table, showing for each of the products
  how many times it was ordered, at which time and all comments to each product from the order*/
(SELECT order_id AS NumberOfTable, name AS NameOfFoodsAndDrinks, 
	count(food_id) AS HowManyTimes, order_time AS OrderTime, comments AS Comments
FROM order_food JOIN foods
ON food_id = foods.id
JOIN orders
ON orders.numOfTable = order_food.order_id
WHERE order_id = 1
GROUP BY food_id)
UNION
(SELECT order_id AS NumberOfTable, name AS NameOfFoodsAndDrinks, 
	count(drink_id) AS HowManyTimes, order_time AS OrderTime, comments AS Comments
FROM order_drink JOIN drinks
ON drink_id = drinks.id
JOIN orders
ON orders.numOfTable = order_drink.order_id
WHERE order_id = 1
GROUP BY drink_id) 
ORDER BY NumberOfTable ASC;

#Task 23
#Showing all wines in the menu using INNER JOIN
SELECT name, volume AS ml, price, color, typeOfGrape, winery, year, country 
FROM drinks JOIN wines
ON drinks.id = wines.drink_id;

#Task 4
#Showing all waiters even if they don't have tables in the moment using OUTTER JOIN
SELECT numOfTable, name
FROM orders
RIGHT JOIN waiters
ON waiter_id = waiters.id;    

#Task 5
#Showing the entire bill to a specific table
SELECT numOfTable AS NumberOfTable, sum(foods_drinks.price) AS FullPrice
FROM orders    
JOIN (
	(SELECT SUM(price) AS price
    FROM foods JOIN order_food
    ON food_id = foods.id
    WHERE order_id = 2)
	UNION
	(SELECT SUM(price) AS price
    FROM drinks JOIN order_drink
    ON drink_id = drinks.id
    WHERE order_id = 2)
) AS foods_drinks
WHERE numOfTable = 2;

#Task 6
/* Showing all products with a specific allergen, passed as a procedure parameter, using a cursor;
  in case of an invalid or non-allergenic dish, a message is displayed */
DELIMITER //
CREATE PROCEDURE foodsWithConcreteAllergen(IN typeAllergen VARCHAR(100))
BEGIN
    DECLARE tempFoodName VARCHAR(100);
    DECLARE tempFoodType VARCHAR(100);
    DECLARE tempFoodWeight DOUBLE;
    DECLARE tempLunchMenu VARCHAR(3);
    DECLARE tempFoodIngredients TEXT;
	DECLARE finished INT; 
    
	DECLARE foodCursor CURSOR FOR
		SELECT name, type, weight, lunchMenu, ingredients
		FROM foods
		WHERE find_in_set(typeAllergen, allergens) != 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    SET finished = 0;
    OPEN foodCursor;
        
    IF((SELECT sum(find_in_set(typeAllergen, allergens)) FROM foods) = 0)
    THEN
		SELECT 'Allergen is incorrect or there is no food with this allergen!' AS result;
	ELSE
		food_loop: 
		WHILE(finished = 0)
		DO	
			FETCH foodCursor INTO tempFoodName, tempFoodType, tempFoodWeight, tempLunchMenu, tempFoodIngredients;
			IF (finished = 1)
			THEN
				LEAVE food_loop;
			END IF;
			SELECT tempFoodName, tempFoodType, tempFoodWeight, tempLunchMenu, tempFoodIngredients;
		END WHILE;	
    END IF;
    CLOSE foodCursor;
    SET finished = 0;
END;
//
DELIMITER ;
CALL foodsWithConcreteAllergen('Яйца и продукти от тях');

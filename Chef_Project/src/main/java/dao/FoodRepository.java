package dao;

import java.util.ArrayList;
import dto.Food;

public class FoodRepository {
   
   private ArrayList<Food> listOfFoods=new ArrayList<Food>();
   private static FoodRepository instance = new FoodRepository();
   
   public static FoodRepository getInstance() {
      return instance;
   }

   public FoodRepository() {
      Food food1 = new Food("시금치", 4000);
      food1.setDescription("시금치는 100g당 약 30kcal의 저열량 식품이면서도 비타민, 무기질, 식이섬유가 풍부한 '채소의 왕'입니다."
            + "특히 뼈 건강, 빈혈 예방, 면역력 증진에 탁월한 효능을 가지고 있습니다");
      food1.setDate("2026/12/31");
      food1.setPlace("M마트");
      food1.setUnitsInStock(3);
      food1.setFilename("시금치.jpg");
      
      
      Food food2 = new Food("콩나물", 2500);
      food2.setDescription("콩나물은 아스파라긴산, 비타민 C, 이소플라본, 양질의 단백질이 풍부한 저칼로리 채소입니다."
            + "간 기능 개선 및 숙취 해소, 면역력 강화, 피부 미용, 그리고 갱년기 증상 완화와 뼈 건강에 매우 탁월한 효능을 가지고 있습니다.");
      food2.setDate("2026/12/31");
      food2.setPlace("M마트");
      food2.setUnitsInStock(5);
      food2.setFilename("콩나물.jpg");
      
      
      Food food3 = new Food("당근", 3000);
      food3.setDescription("당근은 칼로리가 낮고(100g당 약 34~37kcal) 수분과 식이섬유가 풍부해 다이어트와 장 건강에 좋습니다."
            + "특히 항산화 물질인 베타카로틴의 보고로, 체내에서 비타민 A로 전환되어 눈 건강과 면역력 증진에 탁월한 효과가 있습니다.");
      food3.setDate("2026/12/31");
      food3.setPlace("M마트");
      food3.setUnitsInStock(8);
      food3.setFilename("당근.jpg");
      
      
      listOfFoods.add(food1);
      listOfFoods.add(food2);
      listOfFoods.add(food3);

   }
   
   public ArrayList<Food> getAllFoods() {
      return listOfFoods;
   }
   
   public void addFood(Food food) {
      listOfFoods.add(food);
   }
   
   public Food getFoodById(String foodName) {
      Food foodById = null;

      for (int i = 0; i < listOfFoods.size(); i++) {
         Food food = listOfFoods.get(i);
         
         //꺼내온 식재료가 비어있지 않고, 이름 글자가 foodName과 100% 일치하면!
         if (food != null && food.getFoodname() != null && food.getFoodname().equals(foodName)) {
            foodById = food; //찾은 식재료를 주머니에 담고
            break; //찾았으니 반복문 종료
         }
      }
      return foodById; //찾은 식재료 객체를 JSP로 배달
   }

}

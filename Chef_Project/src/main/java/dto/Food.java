package dto;

import java.io.Serializable;

public class Food implements Serializable {
   
   private static final long serialVersionUID=-4274700572038677000L;
   
   private String foodname; //재료이름
   private String description; //설명
   private int price; //가격
   private String date; //유통기한
   private String place; //구매처
   private long unitsInStock; //재고개수
   private String filename; //이미지 파일명
   private int quantity;
   
   
   public Food() {
      super();
   }
   
   public Food(String foodname, Integer price) {
      this.foodname=foodname;
      this.price=price;
   }
   
   public String getFoodname() {
      return foodname;
   }
   public void setFoodname(String foodname) {
      this.foodname = foodname;
   }
   
   public String getDescription() {
      return description;
   }
   public void setDescription(String description) {
      this.description = description;
   }
   
   public int getPrice() {
      return price;
   }
   public void setPrice(int price) {
      this.price = price;
   }
   
   public String getDate() {
      return date;
   }
   public void setDate(String date) {
      this.date = date;
   }
   
   public String getPlace() {
      return place;
   }
   public void setPlace(String place) {
      this.place = place;
   }
   
   public long getUnitsInStock() {
      return unitsInStock;
   }
   public void setUnitsInStock(long unitsInStock) {
      this.unitsInStock = unitsInStock;
   }
   
   public String getFilename() {
      return filename;
   }
   public void setFilename(String filename) {
      this.filename = filename;
   }
   
   public int getQuantity() {
      return quantity;
   }
   public void setQuantity(int quantity) {
      this.quantity = quantity;
   }
   
   public static long getSerialversionuid() {
      return serialVersionUID;
   }
}
   
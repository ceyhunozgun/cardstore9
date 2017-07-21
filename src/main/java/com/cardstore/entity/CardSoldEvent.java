package com.cardstore.entity;

public class CardSoldEvent {
	private String name;
	private double price;
	private String oldOwner;
	private double oldOwnerBalance;
	private String newOwner;
	
	public CardSoldEvent(String name, double price, String oldOwner, double oldOwnerBalance, String newOwner) {
		super();
		this.name = name;
		this.price = price;
		this.oldOwner = oldOwner;
		this.oldOwnerBalance = oldOwnerBalance;
		this.newOwner = newOwner;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public String getOldOwner() {
		return oldOwner;
	}
	public void setOldOwner(String oldOwner) {
		this.oldOwner = oldOwner;
	}
	public double getOldOwnerBalance() {
		return oldOwnerBalance;
	}
	public void setOldOwnerBalance(double oldOwnerBalance) {
		this.oldOwnerBalance = oldOwnerBalance;
	}
	public String getNewOwner() {
		return newOwner;
	}
	public void setNewOwner(String newOwner) {
		this.newOwner = newOwner;
	}
}

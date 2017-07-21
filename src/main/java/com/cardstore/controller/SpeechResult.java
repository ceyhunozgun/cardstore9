package com.cardstore.controller;

public class SpeechResult {
	public enum SPEECH_COMMAND { UNKNOWN, ADD_CARD, SHOW_MY_CARDS, SELL_CARD, LOGOUT };
	
	SpeechResult.SPEECH_COMMAND command;
	String cardName;
	String cardPrice;
	String inputText;
	String responseText;
	
	public SpeechResult.SPEECH_COMMAND getCommand() {
		return command;
	}
	public void setCommand(SpeechResult.SPEECH_COMMAND command) {
		this.command = command;
	}
	public String getCardName() {
		return cardName;
	}
	public void setCardName(String cardName) {
		this.cardName = cardName;
	}
	public String getCardPrice() {
		return cardPrice;
	}
	public void setCardPrice(String cardPrice) {
		this.cardPrice = cardPrice;
	}
	public String getInputText() {
		return inputText;
	}
	public void setInputText(String inputText) {
		this.inputText = inputText;
	}
	public String getResponseText() {
		return responseText;
	}
	public void setResponseText(String responseText) {
		this.responseText = responseText;
	}
}

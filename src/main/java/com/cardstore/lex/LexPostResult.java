package com.cardstore.lex;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class LexPostResult {
	private String intentName;
	private String dialogState;
	private Map<String, String> slots;
	private String slotToElicit;
	private Map<String, String> sessionAttributes;
	private byte[] audio;
	private String inputText;
	private String responseText;
	
	public LexPostResult(String intentName, String dialogState, String slots, String slotToElicit,
			String sessionAttributes, byte[] audio, String inputText, String responseText) throws Exception {
		super();
		this.intentName = intentName;
		this.dialogState = dialogState;
		this.slots = stringToMap(slots);
		this.slotToElicit = slotToElicit;
		this.sessionAttributes = stringToMap(sessionAttributes);
		this.audio = audio;
		this.inputText = inputText;
		this.responseText = responseText;
	}

	private Map<String, String> stringToMap(String jsonStr) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		
		if (jsonStr != null) {
			ObjectMapper mapper = new ObjectMapper();


			// convert JSON string to Map
			map = mapper.readValue(jsonStr, new TypeReference<Map<String, String>>(){});
		}
		return map;
	}

	public String getIntentName() {
		return intentName;
	}

	public String getDialogState() {
		return dialogState;
	}

	public Map<String, String> getSlots() {
		return slots;
	}

	public String getSlotToElicit() {
		return slotToElicit;
	}

	public Map<String, String> getSessionAttributes() {
		return sessionAttributes;
	}

	public byte[] getAudio() {
		return audio;
	}

	public String getInputText() {
		return inputText;
	}

	public String getResponseText() {
		return responseText;
	}
}
package com.cardstore.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.cardstore.entity.User;
import com.cardstore.lex.LexClient;
import com.cardstore.lex.LexPostResult;

@Controller
public class SpeechController {
	
	private static final String CONTENT_TYPE = "audio/x-l16; sample-rate=16000; channel-count=1";
	private static final String ACCEPT = "audio/mpeg";

	private static final String USER_LEX_CLIENT_KEY = "USER_LEX_CLIENT_KEY";
	private static final String USER_SPEECH_RESPONSE_AUDIO_KEY = "USER_SPEECH_RESPONSE_AUDIO_KEY";
	

	@RequestMapping(path="/speech")
	@ResponseBody
	public SpeechResult speechCommand(InputStream requestBodyStream, HttpSession session) throws Exception {
		SpeechResult res = null;
		User user = UserController.userfromSession(session);
		
		if (user != null) {
			LexClient client = getLextClientFromSession(session);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			StreamUtils.copy(requestBodyStream, baos);
			
			byte[] audio = baos.toByteArray();
			LexPostResult ret = client.post(CONTENT_TYPE, audio, ACCEPT);
			
			res = createSpeechResultFromLexPostResult(ret);
			
			putSpeechResponseAudioIntoSession(session, ret.getAudio());
		}
		return res;
	}
	
	private SpeechResult createSpeechResultFromLexPostResult(LexPostResult ret) {
		SpeechResult res = new SpeechResult();
		
		res.setCommand(SpeechResult.SPEECH_COMMAND.UNKNOWN);
		res.setInputText(ret.getInputText());
		res.setResponseText(ret.getResponseText());
		
		if (ret.getDialogState().equals("ReadyForFulfillment")) {
			if (ret.getIntentName().equals("LogOut"))
				res.setCommand(SpeechResult.SPEECH_COMMAND.LOGOUT);
			else if (ret.getIntentName().equals("AddCard")) {
				res.setCommand(SpeechResult.SPEECH_COMMAND.ADD_CARD);
			}
			else if (ret.getIntentName().equals("ShowMyCards")) {
				res.setCommand(SpeechResult.SPEECH_COMMAND.SHOW_MY_CARDS);
			}
			else if (ret.getIntentName().equals("SellACard")) {
				res.setCommand(SpeechResult.SPEECH_COMMAND.SELL_CARD);
				res.setCardName(ret.getSlots().get("CardName"));
				res.setCardPrice(ret.getSlots().get("CardPrice"));
			}
		}
		
		return res;
	}

	@RequestMapping(path="/speechResponseAudio", produces="audio/mpeg3")
	public @ResponseBody byte[] speechResponseAudio(HttpSession session) throws IOException {
			return getSpeechResponseAudioFromSession(session);
	}
	
	public static LexClient getLextClientFromSession(HttpSession session) {
		return (LexClient)session.getAttribute(USER_LEX_CLIENT_KEY);
	}
	public static void putLexClientIntoSession(HttpSession session, LexClient client) {
		session.setAttribute(USER_LEX_CLIENT_KEY, client);
	}
	
	public static byte[] getSpeechResponseAudioFromSession(HttpSession session) {
		return (byte[])session.getAttribute(USER_SPEECH_RESPONSE_AUDIO_KEY);
	}
	public static void putSpeechResponseAudioIntoSession(HttpSession session, byte[] audio) {
		session.setAttribute(USER_SPEECH_RESPONSE_AUDIO_KEY, audio);
	}

	public static void initLexClient(HttpSession session, String sessionId) {
		LexClient client = new LexClient(Region.getRegion(Regions.US_EAST_1), "CardStore", "$LATEST", sessionId);
		putLexClientIntoSession(session, client);
	}
}

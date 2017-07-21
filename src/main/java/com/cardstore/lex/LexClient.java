package com.cardstore.lex;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import org.springframework.util.StreamUtils;

import com.amazonaws.regions.Region;
import com.amazonaws.services.lexruntime.AmazonLexRuntime;
import com.amazonaws.services.lexruntime.AmazonLexRuntimeClient;
import com.amazonaws.services.lexruntime.AmazonLexRuntimeClientBuilder;
import com.amazonaws.services.lexruntime.model.PostContentRequest;
import com.amazonaws.services.lexruntime.model.PostContentResult;

public class LexClient {

	private final AmazonLexRuntime lex;
	private final String botName;
	private final String botAlias;
	private final String username;
	
	public LexClient(Region region, String botName, String botAlias, String username) {
		this.botName = botName;
		this.botAlias = botAlias;
		this.username = username;
		
		AmazonLexRuntimeClientBuilder builder = AmazonLexRuntimeClient.builder();
		builder.setRegion(region.getName());
		
		lex = builder.build();
	}

	public LexPostResult post(String contentType, byte[] audio, String accept) throws Exception {
		
		PostContentRequest req = new PostContentRequest();
		
		req.setBotName(botName);
		req.setBotAlias(botAlias);
		req.setUserId(username);
		req.setAccept(accept);
		req.setContentType(contentType);
		InputStream is = new ByteArrayInputStream(audio);
		req.setInputStream(is);
		
		PostContentResult ret = lex.postContent(req);

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		StreamUtils.copy(ret.getAudioStream(), baos);
				
		LexPostResult res = new LexPostResult(ret.getIntentName(), ret.getDialogState(), ret.getSlots(), ret.getSlotToElicit(), ret.getSessionAttributes(), baos.toByteArray(), ret.getInputTranscript(), ret.getMessage());
		
		return res;
	}
}

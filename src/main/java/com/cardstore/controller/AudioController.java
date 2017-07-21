package com.cardstore.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.polly.model.OutputFormat;
import com.cardstore.polly.PollyHelper;

@Controller
public class AudioController {

	@RequestMapping(path="/audio", produces="audio/mpeg3")
	public @ResponseBody byte[] textToSpeech(@RequestParam("msg") String msg) throws IOException {
			PollyHelper helper = new PollyHelper(Region.getRegion(Regions.EU_WEST_1));
			
			InputStream is = helper.synthesize(msg, OutputFormat.Mp3);
			
			return StreamUtils.copyToByteArray(is);
	}
}

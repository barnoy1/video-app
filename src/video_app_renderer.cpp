/*******************************************************************
** This code is part of Breakout.
**
** Breakout is free software: you can redistribute it and/or modify
** it under the terms of the CC BY 4.0 license as published by
** Creative Commons, either version 4 of the License, or (at your
** option) any later version.
******************************************************************/
#include <algorithm>
#include <sstream>
#include <iostream>
#include <filesystem.h>
#include <math.h>


#define posix_memalign_free _aligned_free
#define posix_memalign(p, a, s) (((*(p)) = _aligned_malloc((s), (a))), *(p) ?0 :errno)


#include "video_app_renderer.h"
#include "resource_manager.h"
#include "sprite_renderer.h"
#include "render_object.h"

#include "post_processor.h"
#include "text_renderer.h"
#include "glm/glm.hpp"
#include "video_reader.hpp"

// VideoAppRenderer-related State data
SpriteRenderer    *Renderer;
RenderObject        *Compass;
PostProcessor     *Effects;
TextRenderer      *Text;

float ShakeTime = 0.0f;



VideoAppRenderer::VideoAppRenderer(unsigned int width, unsigned int height) 
    : Keys(), KeysProcessed(), Width(width), Height(height)
{ 
	
}

VideoAppRenderer::~VideoAppRenderer()
{
    delete Renderer;
    delete Compass;
    delete Effects;
    delete Text;
}


void VideoAppRenderer::Init()
{
    // load shaders
	std::string SpriteVsPath = FileSystem::getPath("shaders/sprite.vs");
	std::string SpriteFsPath = FileSystem::getPath("shaders/sprite.fs");
	std::string PostProcVsPath = FileSystem::getPath("shaders/post_processing.vs");
	std::string PostProcFsPath = FileSystem::getPath("shaders/post_processing.fs");
    ResourceManager::LoadShader(SpriteVsPath.c_str(), SpriteFsPath.c_str(), nullptr, "sprite");
    ResourceManager::LoadShader(PostProcVsPath.c_str(), PostProcFsPath.c_str(), nullptr, "postprocessing");
    // configure shaders
    glm::mat4 projection = glm::ortho(0.0f, static_cast<float>(this->Width), static_cast<float>(this->Height), 0.0f, -1.0f, 1.0f);
    ResourceManager::GetShader("sprite").Use().SetInteger("sprite", 0);
    ResourceManager::GetShader("sprite").SetMatrix4("projection", projection);
    ResourceManager::GetShader("particle").Use().SetInteger("sprite", 0);
    ResourceManager::GetShader("particle").SetMatrix4("projection", projection);
    // load textures
    
    ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/compass.png").c_str(), false, "compass");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/background.jpg").c_str(), false, "background");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/awesomeface.png").c_str(), true, "face");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/block.png").c_str(), false, "block");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/block_solid.png").c_str(), false, "block_solid");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/paddle.png").c_str(), true, "paddle");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/particle.png").c_str(), true, "particle");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_speed.png").c_str(), true, "powerup_speed");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_sticky.png").c_str(), true, "powerup_sticky");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_increase.png").c_str(), true, "powerup_increase");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_confuse.png").c_str(), true, "powerup_confuse");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_chaos.png").c_str(), true, "powerup_chaos");
	ResourceManager::LoadTexture(FileSystem::getPath("assets/textures/powerup_passthrough.png").c_str(), true, "powerup_passthrough");


	// Allocate frame buffer   
	if (!video_reader_open(&vr_state, "C:/repo/video-app/assets/GEFN0004 Good_Segment_0_x264.mp4")) {
		printf("Couldn't open video file (make sure you set a video file that exists)\n");
	}
	constexpr int ALIGNMENT = 128;
	const int frame_width = vr_state.width;
	const int frame_height = vr_state.height;
	uint8_t* frame_data;
	if (posix_memalign((void**)&frame_data, ALIGNMENT, frame_width * frame_height * 4) != 0) {
		printf("Couldn't allocate frame buffer\n");
	}

	// Read a new frame and load it into texture
	int64_t pts;
	if (!video_reader_read_frame(&vr_state, frame_data, &pts)) {
		printf("Couldn't load video frame\n");
	}
	ResourceManager::loadTextureFromStream(frame_width, frame_height, frame_data, true, "video_feed");

    // set render-specific controls
    Renderer = new SpriteRenderer(ResourceManager::GetShader("sprite"));
    Effects = new PostProcessor(ResourceManager::GetShader("postprocessing"), this->Width, this->Height);
    Text = new TextRenderer(this->Width, this->Height);
    Text->Load(FileSystem::getPath("assets/fonts/OCRAEXT.TTF").c_str(), 24);
    // configure game objects
    glm::vec2 playerPos = glm::vec2(this->Width / 2.0f - COMPASS_SIZE.x / 2.0f, this->Height - COMPASS_SIZE.y);
	Compass = new RenderObject(playerPos, COMPASS_SIZE, ResourceManager::GetTexture("compass"));
   
	
	Info.startTime = glfwGetTime();
}


void VideoAppRenderer::ProcessInput(float dt)
{

	float velocity = COMPASS_VELOCITY * dt;

	if (this->Keys[GLFW_KEY_DOWN])
	{
		Effects->Brightness -= 0.005;
		Effects->Brightness = std::max(0.0f, Effects->Brightness);
	}
	if (this->Keys[GLFW_KEY_UP])
	{
		Effects->Brightness += 0.005;
		Effects->Brightness = std::min(10.0f, Effects->Brightness);
	}

	if (this->Keys[GLFW_KEY_SPACE])
	{
		Effects->Brightness = 1;		
	}

	if (this->Keys[GLFW_KEY_A])
	{
		if (Compass->Position.x >= 0.0f)
		{
			Compass->Position.x -= velocity;
		}
	}
	if (this->Keys[GLFW_KEY_D])
	{
		if (Compass->Position.x <= this->Width - Compass->Size.x)
		{
			Compass->Position.x += velocity;
		}
	}


	if (this->Keys[GLFW_KEY_W])
	{
		if (Compass->Position.y >= 0.0f)
		{
			Compass->Position.y -= velocity;
		}
	}
	if (this->Keys[GLFW_KEY_S])
	{
		if (Compass->Position.y <= this->Height - Compass->Size.x)
		{
			Compass->Position.y += velocity;
		}
	}

	Compass->Position.x = std::max(0.0f, Compass->Position.x);
	Compass->Position.y = std::max(0.0f, Compass->Position.y);

}

void VideoAppRenderer::Render()
{
	// Measure speed
	double currentTime = glfwGetTime();
	Info.deltaTime = (currentTime - Info.previousTime);
	
	// play at 30fps.
	if (Info.deltaTime >= 0.03)
	{		
		Info.frameCount++;
		Info.previousTime = currentTime;
		Info.deltaTime = 0;

		constexpr int ALIGNMENT = 128;
		const int frame_width = vr_state.width;
		const int frame_height = vr_state.height;
		uint8_t* frame_data;
		if (posix_memalign((void**)&frame_data, ALIGNMENT, frame_width * frame_height * 4) != 0) {
			printf("Couldn't allocate frame buffer\n");
		}


		// Read a new frame and load it into texture
		int64_t pts;
		if (!video_reader_read_frame(&vr_state, frame_data, &pts)) {
			printf("Couldn't load video frame\n");
		}

		ResourceManager::GetTexture("video_feed").BindStreamedTexture(frame_width, frame_height, frame_data);

	}
    double runTime = currentTime - Info.startTime;

    double fps = Info.frameCount / runTime;
	
	// begin rendering to postprocessing framebuffer
	Effects->BeginRender();
	// draw background

	Renderer->DrawSprite(ResourceManager::GetTexture("video_feed"), glm::vec2(0.0f, 0.0f), glm::vec2(this->Width, this->Height), 0.0f);

	//Renderer->DrawSprite(ResourceManager::GetTexture("background"), glm::vec2(0.0f, 0.0f), glm::vec2(this->Width, this->Height), 0.0f);          
	// draw player
	double compassRenderStart = glfwGetTime();
	Compass->Alpha = 0.25f;
	Compass->Draw(*Renderer);
	double compassRenderEnd = glfwGetTime();	
	double compassRenderTime = (compassRenderEnd - compassRenderStart) * 1000.0f;

	// end rendering to postprocessing framebuffer
	Effects->EndRender();
	// render postprocessing quad
	Effects->Render(glfwGetTime());
	// render text (don't include in postprocessing)

	std::stringstream ssFps;
	ssFps << fps;
	Text->RenderText("Video FPS:" + ssFps.str(), 5.0f, 5.0f, 1.0f, Info.color);

	std::stringstream ssCompassRenderingTime;
	ssCompassRenderingTime << compassRenderTime;
	Text->RenderText("Compass Render Time (ms):" + ssCompassRenderingTime.str(), 5.0, 40.0f, 1.0f, Info.color);
   
}


void VideoAppRenderer::MouseCallback(double xpos, double ypos)
{
    if (this->Keys[GLFW_KEY_LEFT_SHIFT])
    {
		if (xpos <= this->Width - Compass->Size.x)
		{
			Compass->Position.x = xpos;
		}

		if (ypos <= this->Height - Compass->Size.y)
		{
			Compass->Position.y = ypos;
		}
        Compass->Position.x = std::max(0.0f, Compass->Position.x);
        Compass->Position.y = std::max(0.0f, Compass->Position.y);
       
    }
	
}


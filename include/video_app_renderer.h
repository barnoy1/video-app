
#ifndef VIDEO_APP_RENDERER_H
#define VIDEO_APP_RENDERER_H
#include <vector>
#include <tuple>

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <filesystem.h>
#include "glm/glm.hpp"
#include "render_object.h"
#include "video_reader.hpp"
#include "glm/glm.hpp"

const glm::vec2 COMPASS_SIZE(300.0f, 300.0f);
const float COMPASS_VELOCITY(500.0f);


struct VideoAppInfo
{
	int frameCount = 0;
    double previousTime = 0.0, currentTime = 0.0, startTime = 0.0, deltaTime = 0.0f;
    glm::vec3 color = glm::vec3(0.0, 1.0f, 0.2f);
	double limitFPS = 1.0 / 30.0;	

};
// VideoAppRenderer holds all VideoAppRenderer-related state and functionality.
// Combines all VideoAppRenderer-related data into a single class for
// easy access to each of the components and manageability.
class VideoAppRenderer
{
public:
    // VideoAppRenderer state
    bool                    Keys[1024];
    bool                    KeysProcessed[1024];
    unsigned int            Width, Height;
    VideoAppInfo     Info;

    // constructor/destructor
    VideoAppRenderer(unsigned int width, unsigned int height);
    ~VideoAppRenderer();
    // initialize VideoAppRenderer state (load all shaders/textures/levels)
    void Init();

    // VideoAppRenderer loop
    void ProcessInput(float dt);
    void MouseCallback(double xpos, double ypos);
    void Render();
    
   

private:
    VideoReaderState vr_state;    
};

#endif
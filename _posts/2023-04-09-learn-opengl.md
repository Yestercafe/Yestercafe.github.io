---
layout: post
title: Learn OpenGL
categories: CG
tags: [CG]
---

## Shaders

### The Graphics Pipeline

Sections:

1. Vertex shader. Input single vertices, transform their 3D coordinates to different 3D coordinates (via viewport matrix?), process attributes.
2. Primitive assembly. Assemble the primitive shape with all vertices.
3. Geometry shader. Can emit new more vertices and generate primitives.
4. Rasterization stage. Maps the resulting primitives to the corresponding pixels, do clipping.
5. Fragment shader. Calculate color of a pixel, and be usually where the effects occur.
6. Alpha test and blending.



Reference:
1. <https://learnopengl.com/>
2. <https://github.com/Yescafe/LearnOpenGL> (private currently)
3. <https://lazarus-glhf.github.io/computer/graphics/2023/01/10/LearnOpenGL-Part%E2%85%A0/>

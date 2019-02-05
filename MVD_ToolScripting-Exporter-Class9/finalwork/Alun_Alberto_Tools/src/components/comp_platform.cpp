#pragma once
#include "comp_platform.h"
#include "../EntityComponentStore.h"
#include "../extern.h"

//////////////////////////////////////////////////////////
////////////////// CUSTOM COMPONENTS /////////////////////
//////////////////////////////////////////////////////////


// Important function, this causes the rotation.
void Platform::update(float dt) {

	if (ECS.entities.size() != 0) {

		Entity ent = ECS.entities[owner];
		Transform& platform = ECS.getComponentFromEntity<Transform>(owner);
		//rotator.rotateLocal(speed * dt, axis);
		platform.translate(direction.normalize() * dt * speed);
	}
}

// Save to json
void Platform::Save(rapidjson::Document & json, rapidjson::Value & entity)
{
	rapidjson::Value obj(rapidjson::kObjectType);
	rapidjson::Document::AllocatorType& allocator = json.GetAllocator();

	// Set translation
	{
		rapidjson::Value nsdirection(rapidjson::kArrayType);
		nsdirection.PushBack(direction.x, allocator);
		nsdirection.PushBack(direction.y, allocator);
		nsdirection.PushBack(direction.z, allocator);
		//obj.AddMember("axis", naxis, allocator);
		obj.AddMember("direction", nsdirection, allocator);
		obj.AddMember("speed", speed, allocator);
	}

	entity.AddMember("platform", obj, allocator);
}

// Load method from json
void Platform::Load(rapidjson::Value & entity, int ent_id) {

	auto json_sp = entity["platform"]["speed"].GetFloat();
	auto json_direction = entity["platform"]["direction"].GetArray();

	speed = json_sp;
	direction = lm::vec3(json_direction[0].GetFloat(), json_direction[1].GetFloat(), json_direction[2].GetFloat());
}

// Debug on ImGui
void Platform::debugRender() {

	ImGui::AddSpace(0, 5);
	if (ImGui::TreeNode("Platform")) {
		ImGui::AddSpace(0, 5);
		ImGui::DragFloat3("Translate X", &direction.x);
		ImGui::DragFloat3("Translate Y", &direction.y);
		ImGui::DragFloat3("Translate Z", &direction.z);
		ImGui::DragFloat("Speed", &speed);
		ImGui::TreePop();
	}

	ImDrawList*   draw_list = ImGui::GetWindowDrawList();
	ImVec2 p = ImGui::GetCursorScreenPos();
	draw_list->AddLine(ImVec2(p.x - 9999, p.y), ImVec2(p.x + 9999, p.y), ImGui::GetColorU32(ImGuiCol_Border));
}
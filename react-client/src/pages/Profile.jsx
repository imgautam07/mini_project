// src/pages/Profile.jsx
import React from "react";

const Profile = () => {
  return (
    <div>
      <h1 className="text-4xl font-bold">Your Profile</h1>
      <div className="flex items-center space-x-4 mt-4">
        <div className="w-24 h-24 bg-gray-300 rounded-full"></div> {/* Profile Picture */}
        <div>
          <h2 className="text-xl">User Name</h2>
          <p className="text-gray-600">Followers: 150</p>
          <p className="text-gray-600">Following: 200</p>
        </div>
      </div>
      <div className="mt-8">
        <h2 className="text-2xl font-semibold">Your Posts</h2>
        {/* List of posts */}
        <div className="bg-gray-100 p-6 mt-4 rounded-lg shadow-md">
          <p className="text-sm text-gray-700">This is your first post.</p>
        </div>
        <div className="bg-gray-100 p-6 mt-4 rounded-lg shadow-md">
          <p className="text-sm text-gray-700">This is your second post.</p>
        </div>
      </div>
    </div>
  );
};

export default Profile;

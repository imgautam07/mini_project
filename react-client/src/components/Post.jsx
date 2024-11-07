/* eslint-disable no-unused-vars */
// src/components/Post.jsx
import React from "react";

// eslint-disable-next-line react/prop-types
const Post = ({ username, images }) => {
  return (
    <div className="bg-white rounded-lg shadow p-4 max-w-md mx-auto mb-6">
      {/* Header */}
      <div className="flex items-center mb-4">
        <img
          src={`https://i.pravatar.cc/150?img=${Math.floor(Math.random() * 70) + 1}`}
          alt="User avatar"
          className="w-10 h-10 rounded-full mr-4"
        />
        <span className="font-bold">{username}</span>
      </div>
      {/* Images */}
      <div className="space-y-2">
        {images.map((image, index) => (
          <img
            key={index}
            src={image}
            alt={`Post ${index + 1}`}
            className="w-full rounded-lg"
          />
        ))}
      </div>
    </div>
  );
};

export default Post;

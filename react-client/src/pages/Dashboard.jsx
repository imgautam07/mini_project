import React from "react";

const Dashboard = () => {
  return (
    <div className="p-8">
      <h1 className="text-4xl font-bold text-gray-800 mb-8">Dashboard</h1>

      {/* Feed Section */}
      <div className="flex flex-col items-center lg:items-start lg:flex-row lg:space-x-12 p-8">
        {/* Feed Post 1 */}
        <div className="bg-white p-6 w-full max-w-3xl rounded-xl shadow-lg mb-8 lg:mb-0">
          <div className="flex items-center space-x-4 mb-4">
            <div className="w-14 h-14 bg-gray-300 rounded-full"></div>
            <div className="text-lg font-semibold">User 1</div>
          </div>
          <div className="h-96 bg-gray-300 mb-4 rounded-lg"></div> {/* Placeholder image */}
          <div className="flex justify-between text-sm text-gray-600 mb-2">
            <div>Likes: 120</div>
            <div>Comments: 25</div>
          </div>
          <div className="text-gray-800">
            <strong>User 1</strong>: This is a great post content with a lovely image.
          </div>
          <div className="text-sm text-gray-500 mt-4">Posted on 1 hour ago</div>
        </div>

        {/* Feed Post 2 */}
        <div className="bg-white p-6 w-full max-w-3xl rounded-xl shadow-lg mb-8 lg:mb-0">
          <div className="flex items-center space-x-4 mb-4">
            <div className="w-14 h-14 bg-gray-300 rounded-full"></div>
            <div className="text-lg font-semibold">User 2</div>
          </div>
          <div className="h-96 bg-gray-300 mb-4 rounded-lg"></div> {/* Placeholder image */}
          <div className="flex justify-between text-sm text-gray-600 mb-2">
            <div>Likes: 180</div>
            <div>Comments: 40</div>
          </div>
          <div className="text-gray-800">
            <strong>User 2</strong>: Another awesome post, showing more cool content.
          </div>
          <div className="text-sm text-gray-500 mt-4">Posted on 3 hours ago</div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;

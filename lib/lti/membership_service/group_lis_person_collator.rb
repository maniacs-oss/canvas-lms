#
# Copyright (C) 2011 - 2016 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Lti
  module MembershipService
    class GroupLisPersonCollator < LisPersonCollatorBase
      attr_reader :context, :user

      def initialize(context, user, opts={})
        super(opts)
        @context = context
        @user = user
      end

      private

      def users
        options = {
          enrollment_type: ['teacher', 'ta', 'designer', 'observer', 'student'],
          include_inactive_enrollments: false
        }
        @users ||= UserSearch.scope_for(@context, @user, options)
                             .preload(:communication_channels)
                             .offset(@page * @per_page)
                             .limit(@per_page + 1)
      end

      def generate_roles(user)
        roles = [IMS::LIS::Roles::Context::URNs::Member]
        roles << IMS::LIS::Roles::Context::URNs::Manager if user.id == @context.leader_id
        roles
      end
    end
  end
end
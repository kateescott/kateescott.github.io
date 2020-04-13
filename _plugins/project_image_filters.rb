module Jekyll
  module ProjectImageFilters
    def get_featured_image_path(project)
        info = project['featured_info']
        if !info then return nil end
        image = info['image']
        if !image then return nil end
        assets_root_dir = @context.registers[:site].config['collections']['projects']['img_path']

        File.join(assets_root_dir, project['slug'], image)
    end

    def get_2x_name(filename)
      ext = File.extname(filename)
      File.basename(filename, ext) + "@2x" + ext
    end

    def get_tiles(projects)
      projects.map { |project|
        assets_root_dir = @context.registers[:site].config['collections']['projects']['img_path'][1..-1]
        featured_image_name = project["featured_info"]["image"]
        featured_image_name_2x = get_2x_name(featured_image_name)

        featured_image_path = File.join(assets_root_dir, project['slug'], featured_image_name)
        featured_image_path_2x = File.join(assets_root_dir, project['slug'], featured_image_name_2x)
        has_2x = File.exist?(featured_image_path_2x)

        {
            "href" => project.url,
            "image_path" => "/" + featured_image_path,
            "image_path_2x" => has_2x ? "/" + featured_image_path_2x : nil,
            "style" => project['tile_style'],
            "title" => project['title'],
            "edge_to_edge" => project['featured_info']['edge_to_edge'],
        }
      }
    end

    def get_project_assets(project)
      assets_root_dir = @context.registers[:site].config['collections']['projects']['img_path'][1..-1]
      project_assets_dir = File.join(assets_root_dir, project['slug'], '/')
      unless Dir.exist?(project_assets_dir)
        return []
      end

      assets = Dir.children(project_assets_dir)
                   .select { |file| file.match(/\.(jpe?g|png)$/) }
                   .sort

      if project["featured_info"]["exclude_from_listing"]
        exclude = project["featured_info"]["image"]
        assets = assets.select { |file| file != exclude }
      end

      assets_1x = assets.select { |file| not file.match(/@2x\.([^.]+)$/) }
      assets_1x.map do |file|
        file_2x = get_2x_name(file)
        has_2x = assets.include? file_2x
        {
            "image_path" => "/" + File.join(project_assets_dir, file),
            "image_path_2x" => has_2x ? "/" + File.join(project_assets_dir, file_2x) : nil,
        }
      end
    end

  end
end

Liquid::Template.register_filter(Jekyll::ProjectImageFilters)
